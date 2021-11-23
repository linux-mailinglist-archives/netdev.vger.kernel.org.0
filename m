Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7F445A36E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbhKWNHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:07:11 -0500
Received: from hyperium.qtmlabs.xyz ([194.163.182.183]:43098 "EHLO
        hyperium.qtmlabs.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbhKWNHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:07:08 -0500
Received: from dong.kernal.eu (unknown [14.177.136.153])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id 5272C820104;
        Tue, 23 Nov 2021 14:03:58 +0100 (CET)
Received: from [192.168.43.217] (unknown [27.67.94.78])
        by dong.kernal.eu (Postfix) with ESMTPSA id 232F6444AEE2;
        Tue, 23 Nov 2021 19:57:40 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1637672260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6q6MW7i7K2zAFweeRZuWyCnwbfgdY2+OKgCNVAaav5E=;
        b=rd4nSU1oOKw93ULDbH5L/+NUP0n8xze+/b8dCQ7fNmO5tk3m7DQmbn5uED8QXw5RVoOMTr
        1YMiE2ZsjFsnIiVNvVYhFsRPEccMIpsSUWPaaUqPL3RbOcb+DS5tYedPCuY+XADK0lmLu9
        DOvE9Y8t2Q9DLVNSSP1NzNMpK7Bfkcd5CVO1LyS7sCmyQsxZsupmCQrp2Km/I1B+jO1Y7X
        oJX6RSzVQa11J7lm+whaaxDoS75Ka7u0SUqvna/VUauSnFqTWhxzG0xiPXnxtx7drTnr0J
        hJntrUHa5nsVME4e7Y7jhRhrS7TaDOFyo9ANI0OCiG/lwwrj/tpTuKL0D+fLrw==
Message-ID: <e15bcc8a-4113-bdd9-30e7-9c1352003791@qtmlabs.xyz>
Date:   Tue, 23 Nov 2021 19:57:31 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] ipv6: fix memory leak in fib6_rule_suppress
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20211123124832.15419-1-Jason@zx2c4.com>
From:   msizanoen <msizanoen@qtmlabs.xyz>
In-Reply-To: <20211123124832.15419-1-Jason@zx2c4.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050902000509030000070305"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050902000509030000070305
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/21 19:48, Jason A. Donenfeld wrote:

> From: msizanoen1 <msizanoen@qtmlabs.xyz>
>
> The kernel leaks memory when a `fib` rule is present in IPv6 nftables
> firewall rules and a suppress_prefix rule is present in the IPv6 routing
> rules (used by certain tools such as wg-quick). In such scenarios, every
> incoming packet will leak an allocation in `ip6_dst_cache` slab cache.
>
> After some hours of `bpftrace`-ing and source code reading, I tracked
> down the issue to ca7a03c41753 ("ipv6: do not free rt if
> FIB_LOOKUP_NOREF is set on suppress rule").
>
> The problem with that change is that the generic `args->flags` always have
> `FIB_LOOKUP_NOREF` set[1][2] but the IPv6-specific flag
> `RT6_LOOKUP_F_DST_NOREF` might not be, leading to `fib6_rule_suppress` not
> decreasing the refcount when needed.
>
> How to reproduce:
>   - Add the following nftables rule to a prerouting chain:
>       meta nfproto ipv6 fib saddr . mark . iif oif missing drop
>     This can be done with:
>       sudo nft create table inet test
>       sudo nft create chain inet test test_chain '{ type filter hook prerouting priority filter + 10; policy accept; }'
>       sudo nft add rule inet test test_chain meta nfproto ipv6 fib saddr . mark . iif oif missing drop
>   - Run:
>       sudo ip -6 rule add table main suppress_prefixlength 0
>   - Watch `sudo slabtop -o | grep ip6_dst_cache` to see memory usage increase
>     with every incoming ipv6 packet.
>
> This patch exposes the protocol-specific flags to the protocol
> specific `suppress` function, and check the protocol-specific `flags`
> argument for RT6_LOOKUP_F_DST_NOREF instead of the generic
> FIB_LOOKUP_NOREF when decreasing the refcount, like this.
>
> [1]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
> [2]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215105
> Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> The original author of this commit and commit message is anonymous and
> is therefore unable to sign off on it. Greg suggested that I do the sign
> off, extracting it from the bugzilla entry above, and post it properly.
> The patch "seems to work" on first glance, but I haven't looked deeply
> at it yet and therefore it doesn't have my Reviewed-by, even though I'm
> submitting this patch on the author's behalf. And it should probably get
> a good look from the v6 fib folks. The original author should be on this
> thread to address issues that come off, and I'll shephard additional
> versions that he has.
This patch has been running on my personal laptop since I debugged the 
issue, so you can also add a `Tested-by: <msizanoen@qtmlabs.xyz>`.
>
>   include/net/fib_rules.h | 4 +++-
>   net/core/fib_rules.c    | 2 +-
>   net/ipv4/fib_rules.c    | 1 +
>   net/ipv6/fib6_rules.c   | 4 ++--
>   4 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
> index 4b10676c69d1..bd07484ab9dd 100644
> --- a/include/net/fib_rules.h
> +++ b/include/net/fib_rules.h
> @@ -69,7 +69,7 @@ struct fib_rules_ops {
>   	int			(*action)(struct fib_rule *,
>   					  struct flowi *, int,
>   					  struct fib_lookup_arg *);
> -	bool			(*suppress)(struct fib_rule *,
> +	bool			(*suppress)(struct fib_rule *, int,
>   					    struct fib_lookup_arg *);
>   	int			(*match)(struct fib_rule *,
>   					 struct flowi *, int);
> @@ -218,7 +218,9 @@ INDIRECT_CALLABLE_DECLARE(int fib4_rule_action(struct fib_rule *rule,
>   			    struct fib_lookup_arg *arg));
>   
>   INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
> +						int flags,
>   						struct fib_lookup_arg *arg));
>   INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
> +						int flags,
>   						struct fib_lookup_arg *arg));
>   #endif
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index 79df7cd9dbc1..1bb567a3b329 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -323,7 +323,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
>   		if (!err && ops->suppress && INDIRECT_CALL_MT(ops->suppress,
>   							      fib6_rule_suppress,
>   							      fib4_rule_suppress,
> -							      rule, arg))
> +							      rule, flags, arg))
>   			continue;
>   
>   		if (err != -EAGAIN) {
> diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
> index ce54a30c2ef1..364ad3446b2f 100644
> --- a/net/ipv4/fib_rules.c
> +++ b/net/ipv4/fib_rules.c
> @@ -141,6 +141,7 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_action(struct fib_rule *rule,
>   }
>   
>   INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
> +						int flags,
>   						struct fib_lookup_arg *arg)
>   {
>   	struct fib_result *result = (struct fib_result *) arg->result;
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 40f3e4f9f33a..dcedfe29d9d9 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -267,6 +267,7 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_action(struct fib_rule *rule,
>   }
>   
>   INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
> +						int flags,
>   						struct fib_lookup_arg *arg)
>   {
>   	struct fib6_result *res = arg->result;
> @@ -294,8 +295,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>   	return false;
>   
>   suppress_route:
> -	if (!(arg->flags & FIB_LOOKUP_NOREF))
> -		ip6_rt_put(rt);
> +	ip6_rt_put_flags(rt, flags);
>   	return true;
>   }
>   

--------------ms050902000509030000070305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczMIIC
IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA7eaHlqHBpLbtwkJV9z8PDyJgXxPgpkOI
hkmReRwbLxpQD9xGAe72ujqGzFFh78QPgAhxKVqtGHzYeq0VJVCzhnCKRBbVX+JwIhL3ULYh
UAZrViUp952qDB6qTL5sGeJS9F69VPSR5k6pFNw7mHDTTt0voWFg2aVkG3khomzVXoieJGOi
Q4dH76paCtQbLkt59joAKz2BnwGLQ4wr09nfumJt5AKx2YxHK2XgSPslVZ4z8G00gimsfA7U
tjT/wiekY6Z0b7ksLrEcvODncHQe9VSrNRA149SE3AlkWaZM/joVei/GYfj9K5jkiReinR4m
qM353FEceLOeBhSTURpMdQ5wsXLi9DSTGBuNv4aw2Dozb/qBlkhGTvwk92mi0jAecE22Sn3A
9UfrU2p1w/uRs+TIteQ0xO0B/J2mY2caqocsS9SsriIGlQ8b0LT0o6Ob07KGtPa5/lIvMmx5
72Dv2v+vDiECByxm1Hdgjp8JtE4mdyYP6GBscJyT71NZw1zXHnFkyCbxReag9qaSR9x4CVVX
j1BDmNROCqd5NAfIXUXYTFeZ/jukQigkxXGWhEhfLBC4Ha6pwizz9fq1+wwPKcWaF9P/SZOu
BDrG30MiyCZa66G9mEtF5ZLuh4rGfKqxy4Z5Mxecuzt+MZmrSKfKGeXOeED/iuX5Z02M1o7i
MS8CAwEAAaOCAfQwggHwMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUUtiIOsifeGbt
ifN7OHCUyQICNtAwQQYIKwYBBQUHAQEENTAzMDEGCCsGAQUFBzABhiVodHRwOi8vb2NzcDA1
LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUF
BwIBFiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYI
KwYBBQUHAwIGCCsGAQUFBwMEMIHjBgNVHR8EgdswgdgwgZaggZOggZCGgY1sZGFwOi8vbGRh
cDA1LmFjdGFsaXMuaXQvY24lM2RBY3RhbGlzJTIwQXV0aGVudGljYXRpb24lMjBSb290JTIw
Q0EsbyUzZEFjdGFsaXMlMjBTLnAuQS4lMmYwMzM1ODUyMDk2NyxjJTNkSVQ/Y2VydGlmaWNh
dGVSZXZvY2F0aW9uTGlzdDtiaW5hcnkwPaA7oDmGN2h0dHA6Ly9jcmwwNS5hY3RhbGlzLml0
L1JlcG9zaXRvcnkvQVVUSC1ST09UL2dldExhc3RDUkwwHQYDVR0OBBYEFL6XqaqEv4C/EFN9
CTL54S4yG893MA4GA1UdDwEB/wQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAgEAJpvnG1kNdLMS
A+nnVfeEgIXNQsM7YRxXx6bmEt9IIrFlH1qYKeNw4NV8xtop91Rle168wghmYeCTP10FqfuK
MZsleNkI8/b3PBkZLIKOl9p2Dmz2Gc0I3WvcMbAgd/IuBtx998PJX/bBb5dMZuGV2drNmxfz
3ar6ytGYLxedfjKCD55Yv8CQcN6e9sW5OUm9TJ3kjt7Wdvd1hcw5s+7bhlND38rWFJBuzump
5xqm1NSOggOkFSlKnhSz6HUjgwBaid6Ypig9L1/TLrkmtEIpx+wpIj7WTA9JqcMMyLJ0rN6j
jpetLSGUDk3NCOpQntSy4a8+0O+SepzS/Tec1cGdSN6Ni2/A7ewQNd1Rbmb2SM2qVBlfN0e6
ZklWo9QYpNZyf0d/d3upsKabE9eNCg1S4eDnp8sJqdlaQQ7hI/UYCAgDtLIm7/J9+/S2zuwE
WtJMPcvaYIBczdjwF9uW+8NJ/Zu/JKb98971uua7OsJexPFRBzX7/PnJ2/NXcTdwudShJc/p
d9c3IRU7qw+RxRKchIczv3zEuQJMHkSSM8KM8TbOzi/0v0lU6SSyS9bpGdZZxx19Hd8Qs0cv
+R6nyt7ohttizwefkYzQ6GzwIwM9gSjH5Bf/r9Kc5/JqqpKKUGicxAGy2zKYEGB0Qo761Mcc
IyclBW9mfuNFDbTBeDEyu80xggPzMIID7wIBATCBljCBgTELMAkGA1UEBhMCSVQxEDAOBgNV
BAgMB0JlcmdhbW8xGTAXBgNVBAcMEFBvbnRlIFNhbiBQaWV0cm8xFzAVBgNVBAoMDkFjdGFs
aXMgUy5wLkEuMSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBBdXRoZW50aWNhdGlvbiBDQSBH
MwIQSX8boePDtsxR9Fad9uekcjANBglghkgBZQMEAgEFAKCCAi0wGAYJKoZIhvcNAQkDMQsG
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjExMTIzMTI1NzMxWjAvBgkqhkiG9w0BCQQx
IgQgfg/sP11orIl9f4l7RL55RAtmdlqKq/c59z0kFtnENDAwbAYJKoZIhvcNAQkPMV8wXTAL
BglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDAN
BggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBpwYJKwYBBAGCNxAEMYGZ
MIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUg
U2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBJfxuh48O2zFH0Vp3256RyMIGpBgsqhkiG
9w0BCRACCzGBmaCBljCBgTELMAkGA1UEBhMCSVQxEDAOBgNVBAgMB0JlcmdhbW8xGTAXBgNV
BAcMEFBvbnRlIFNhbiBQaWV0cm8xFzAVBgNVBAoMDkFjdGFsaXMgUy5wLkEuMSwwKgYDVQQD
DCNBY3RhbGlzIENsaWVudCBBdXRoZW50aWNhdGlvbiBDQSBHMwIQSX8boePDtsxR9Fad9uek
cjANBgkqhkiG9w0BAQEFAASCAQDNLpSwJWXd5xzPKItoZ6HK0nS7Es5gSiSM9iVmbtHhGo7U
2VrD63c3AYD//4xRn0v+blSLENErbfQx7/aZVneOHpkM1cN2pIXCekRem6VDfX4nER4Psing
E2w6mgVy20n4N2yxsXqqQyM4SGDKzM+a8HUspybuLY6bttroQKkDrKoxLzL1vSF0uNTmtqyq
QfP/ezxamOF1qQG7NlRezneqc+e95UcW0OKqZilVAp/YpvAW/c1PmDFWeB1cS20TU8zG50Rz
mU82UwMxxdH1oHfpA5h8WzFwrNDds9Eac2u6mxnieHVvPHRe4LuXoR30q0eB/SM6xHeRaXAa
6XiEE3IsAAAAAAAA
--------------ms050902000509030000070305--
