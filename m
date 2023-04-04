Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4224F6D691C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbjDDQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjDDQnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:43:07 -0400
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BF310C2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:43:04 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PrYTv1njnzMqFqP;
        Tue,  4 Apr 2023 18:42:59 +0200 (CEST)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PrYTt3jKcz1kt;
        Tue,  4 Apr 2023 18:42:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1680626579;
        bh=yk8oeeUrlRSVwsk4M+bo4iIySn4IZarWHJF4oLJQ0Fk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=xCOBedGO1yQFCiP+XmP0aSMHFgxFRVJA7mchUeBkp6NVg/q7uMquWy63+2ncjHQZv
         6oeBIQcAKp1GcsAOTPQ6okorJOMxJJS9Hq1xXF2J6kaVPh+qUAF+bjAQ30J11hx3u6
         bEdfbGXMbmQ0OSk5224NhZV7bytxIsEk41+aG8w0=
Content-Type: multipart/mixed; boundary="------------On0rNqP3BGAQZeC4daDmM00S"
Message-ID: <ac4d6244-641b-e1d4-5c34-d9a9bcd10498@digikod.net>
Date:   Tue, 4 Apr 2023 18:42:57 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 09/13] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-10-konstantin.meskhidze@huawei.com>
 <468fbb05-6d72-3570-3453-b1f8bfdd5bc2@digikod.net>
 <1f84d88f-9977-13a9-245a-c75cd3444b29@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <1f84d88f-9977-13a9-245a-c75cd3444b29@huawei.com>
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------On0rNqP3BGAQZeC4daDmM00S
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 04/04/2023 11:31, Konstantin Meskhidze (A) wrote:
> 
> 
> 3/31/2023 8:24 PM, Mickaël Salaün пишет:
>>
>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in the ruleset management
>>> helpers and the landlock_create_ruleset syscall.
>>> Refactor user space API to support network actions. Add new network
>>> access flags, network rule and network attributes. Increment Landlock
>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>> rights can be stored. Implement socket_bind() and socket_connect()
>>> LSM hooks, which enable to restrict TCP socket binding and connection
>>> to specific ports.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v9:
>>> * Changes UAPI port field to __u64.
>>> * Moves shared code into check_socket_access().
>>> * Adds get_raw_handled_net_accesses() and
>>> get_current_net_domain() helpers.
>>> * Minor fixes.
>>>
>>> Changes since v8:
>>> * Squashes commits.
>>> * Refactors commit message.
>>> * Changes UAPI port field to __be16.
>>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>>> * Adds address length checking.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Squashes commits.
>>> * Increments ABI version to 4.
>>> * Refactors commit message.
>>> * Minor fixes.
>>>
>>> Changes since v6:
>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>     because it OR values.
>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>> * Refactors landlock_get_net_access_mask().
>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>     LANDLOCK_NUM_ACCESS_FS as value.
>>> * Updates access_masks_t to u32 to support network access actions.
>>> * Refactors landlock internal functions to support network actions with
>>>     landlock_key/key_type/id types.
>>>
>>> Changes since v5:
>>> * Gets rid of partial revert from landlock_add_rule
>>> syscall.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>> masks checks.
>>> * Refactors landlock_create_ruleset() and landlock mask
>>> setters/getters to support two rule types.
>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>> function by factoring out get_ruleset_from_fd() and
>>> landlock_put_ruleset().
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds network rule support for internal landlock functions.
>>> * Adds set_mask and get_mask for network.
>>> * Adds rb_root root_net_port.
>>>
>>> ---
>>>    include/uapi/linux/landlock.h                |  49 +++++
>>>    security/landlock/Kconfig                    |   1 +
>>>    security/landlock/Makefile                   |   2 +
>>>    security/landlock/limits.h                   |   6 +-
>>>    security/landlock/net.c                      | 198 +++++++++++++++++++
>>>    security/landlock/net.h                      |  26 +++
>>>    security/landlock/ruleset.c                  |  52 ++++-
>>>    security/landlock/ruleset.h                  |  63 +++++-
>>>    security/landlock/setup.c                    |   2 +
>>>    security/landlock/syscalls.c                 |  72 ++++++-
>>>    tools/testing/selftests/landlock/base_test.c |   2 +-
>>>    11 files changed, 450 insertions(+), 23 deletions(-)
>>>    create mode 100644 security/landlock/net.c
>>>    create mode 100644 security/landlock/net.h
>>
>> [...]
>>
>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>
>> [...]
>>
>>> +static int check_addrlen(const struct sockaddr *const address, int addrlen)
>>
>> const int addrlen
> 
>     Got it.
>>
>>> +{
>>> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
>>> +		return -EINVAL;
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +	case AF_INET:
>>> +		if (addrlen < sizeof(struct sockaddr_in))
>>> +			return -EINVAL;
>>> +		return 0;
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>> +		if (addrlen < SIN6_LEN_RFC2133)
>>> +			return -EINVAL;
>>> +		return 0;
>>> +#endif
>>> +	}
>>> +	WARN_ON_ONCE(1);
>>> +	return 0;
>>> +}
>>> +
>>> +static u16 get_port(const struct sockaddr *const address)
>>> +{
>>> +	/* Gets port value in host byte order. */
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +	case AF_INET: {
>>> +		const struct sockaddr_in *const sockaddr =
>>> +			(struct sockaddr_in *)address;
>>> +		return ntohs(sockaddr->sin_port);
>>
>> Storing ports in big endian (in rulesets) would avoid converting them
>> every time the kernel checks a socket port. The above comment should
>> then be updated too.
> 
>     I thought we came to a conclusion to stick to host endianess and
> let kernel do the checks under the hood:
> https://lore.kernel.org/linux-security-module/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net/
> 
> Did I misunderstand something?

We indeed stick to the host endianess for the UAPI/syscalls, but 
internally the kernel has to do the conversion with as it is currently 
done by calling ntohs(). To avoid calling ntohs() every time get_port() 
is called, we can instead only call htons() when creating rules (i.e. 
one-time htons call instead of multiple ntohs calls).


>    Do you mean we need to do port converting __be16 -> u16 in 
> check_socket_access()???

Removing the ntohs() call from get_port() enables to return __be16 
instead of u16, and check_socket_access() will then need to use the same 
type.


>>
>>
>>> +	}
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6: {
>>> +		const struct sockaddr_in6 *const sockaddr_ip6 =
>>> +			(struct sockaddr_in6 *)address;
>>> +		return ntohs(sockaddr_ip6->sin6_port);
>>> +	}
>>> +#endif
>>> +	}
>>> +	WARN_ON_ONCE(1);
>>> +	return 0;
>>> +}
>>> +
>>> +static int check_socket_access(struct socket *sock, struct sockaddr *address, int addrlen, u16 port,
>>> +			       access_mask_t access_request)
>>> +{
>>> +	int ret;
>>> +	bool allowed = false;
>>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>> +	const struct landlock_rule *rule;
>>> +	access_mask_t handled_access;
>>> +	const struct landlock_id id = {
>>> +		.key.data = port,
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +	const struct landlock_ruleset *const domain = get_current_net_domain();
>>> +
>>> +	if (WARN_ON_ONCE(!domain))
>>> +		return 0;
>>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>>> +		return -EACCES;
>>> +	/* Check if it's a TCP socket. */
>>> +	if (sock->type != SOCK_STREAM)
>>> +		return 0;
>>> +
>>> +	ret = check_addrlen(address, addrlen);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +		/*
>>> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
>>> +		 * association, which have the same effect as closing the
>>> +		 * connection while retaining the socket object (i.e., the file
>>> +		 * descriptor).  As for dropping privileges, closing
>>> +		 * connections is always allowed.
>>> +		 */
>>> +		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>> +			return 0;
>>> +
>>> +		/*
>>> +		 * For compatibility reason, accept AF_UNSPEC for bind
>>> +		 * accesses (mapped to AF_INET) only if the address is
>>> +		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
>>> +		 * required to not wrongfully return -EACCES instead of
>>> +		 * -EAFNOSUPPORT.
>>> +		 */
>>> +		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
>>> +			const struct sockaddr_in *const sockaddr =
>>> +				(struct sockaddr_in *)address;
>>> +
>>> +			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
>>> +				return -EAFNOSUPPORT;
>>> +		}
>>> +
>>> +		fallthrough;
>>> +	case AF_INET:
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>> +#endif
>>> +		rule = landlock_find_rule(domain, id);
>>> +		handled_access = landlock_init_layer_masks(
>>> +			domain, access_request, &layer_masks,
>>> +			LANDLOCK_KEY_NET_PORT);
>>> +		allowed = landlock_unmask_layers(rule, handled_access,
>>> +						 &layer_masks,
>>> +						 ARRAY_SIZE(layer_masks));
>>> +	}
>>> +	return allowed ? 0 : -EACCES;
>>> +}
>>> +
>>> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
>>> +			    int addrlen)
>>> +{ >>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>> +				   LANDLOCK_ACCESS_NET_BIND_TCP);

get_port() is called before check_addrlen(), which is an issue.

You'll find attached a patch for these fixes, please squash it in this 
one for the next version.

I'll send other reviews by the end of the week.


>>> +}
>>> +
>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>>> +			       int addrlen)
>>> +{
>>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>> +				   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>> +}
>>
>> [...]
>> .
--------------On0rNqP3BGAQZeC4daDmM00S
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-PATCH-Fix-multiple-issues-in-net.c.patch"
Content-Disposition: attachment;
 filename="0001-PATCH-Fix-multiple-issues-in-net.c.patch"
Content-Transfer-Encoding: base64

RnJvbSBkNmU1M2VhMzE4ZGRmYTMyZTU0NTMyZjQ0NzQxMjkxMTcwOWE4MGUxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/TWlja2E9QzM9QUJsPTIwU2FsYT1D
Mz1CQ24/PSA8bWljQGRpZ2lrb2QubmV0PgpEYXRlOiBUdWUsIDQgQXByIDIwMjMgMTc6Mjg6
MzQgKzAyMDAKU3ViamVjdDogW1BBVENIXSBQQVRDSDogRml4IG11bHRpcGxlIGlzc3VlcyBp
biBuZXQuYwoKLSBTdG9yZSBwb3J0cyBpbiBydWxlc2V0cyBhcyBfX2JlMTYgdG8gYXZvaWQg
cnVudGltZSBjb252ZXJzaW9ucy4KLSBDb25zdGlmeSBhcmd1bWVudHMuCi0gQ2hlY2sgYWRk
cmVzcydzIGxlbmd0aCBiZWZvcmUgZGVyZWZlcmVuY2luZyBhZGRyZXNzIHRvIHJlYWQgdGhl
IHBvcnQuCi0gRml4IGFuZCBhZGQgY29tbWVudHMuCi0gRm9ybWF0IHdpdGggY2xhbmctZm9y
bWF0LgotLS0KIHNlY3VyaXR5L2xhbmRsb2NrL25ldC5jIHwgNTUgKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRp
b25zKCspLCAyMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zZWN1cml0eS9sYW5kbG9j
ay9uZXQuYyBiL3NlY3VyaXR5L2xhbmRsb2NrL25ldC5jCmluZGV4IGUxOWMzMzk5MDZlNy4u
NjYzZWVlNTkyMGQ1IDEwMDY0NAotLS0gYS9zZWN1cml0eS9sYW5kbG9jay9uZXQuYworKysg
Yi9zZWN1cml0eS9sYW5kbG9jay9uZXQuYwpAQCAtMjIsOSArMjIsMTAgQEAgaW50IGxhbmRs
b2NrX2FwcGVuZF9uZXRfcnVsZShzdHJ1Y3QgbGFuZGxvY2tfcnVsZXNldCAqY29uc3QgcnVs
ZXNldCwKIHsKIAlpbnQgZXJyOwogCWNvbnN0IHN0cnVjdCBsYW5kbG9ja19pZCBpZCA9IHsK
LQkJLmtleS5kYXRhID0gcG9ydCwKKwkJLmtleS5kYXRhID0gKF9fZm9yY2UgdWludHB0cl90
KWh0b25zKHBvcnQpLAogCQkudHlwZSA9IExBTkRMT0NLX0tFWV9ORVRfUE9SVCwKIAl9Owor
CiAJQlVJTERfQlVHX09OKHNpemVvZihwb3J0KSA+IHNpemVvZihpZC5rZXkuZGF0YSkpOwog
CiAJLyogVHJhbnNmb3JtcyByZWxhdGl2ZSBhY2Nlc3MgcmlnaHRzIHRvIGFic29sdXRlIG9u
ZXMuICovCkBAIC02MCwyMCArNjEsMjQgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBsYW5kbG9j
a19ydWxlc2V0ICpnZXRfY3VycmVudF9uZXRfZG9tYWluKHZvaWQpCiAJcmV0dXJuIGRvbTsK
IH0KIAotc3RhdGljIGludCBjaGVja19hZGRybGVuKGNvbnN0IHN0cnVjdCBzb2NrYWRkciAq
Y29uc3QgYWRkcmVzcywgaW50IGFkZHJsZW4pCitzdGF0aWMgaW50IGNoZWNrX2FkZHJsZW4o
Y29uc3Qgc3RydWN0IHNvY2thZGRyICpjb25zdCBhZGRyZXNzLAorCQkJIGNvbnN0IGludCBh
ZGRybGVuKQogewogCWlmIChhZGRybGVuIDwgb2Zmc2V0b2ZlbmQoc3RydWN0IHNvY2thZGRy
LCBzYV9mYW1pbHkpKQogCQlyZXR1cm4gLUVJTlZBTDsKKwogCXN3aXRjaCAoYWRkcmVzcy0+
c2FfZmFtaWx5KSB7CiAJY2FzZSBBRl9VTlNQRUM6CiAJY2FzZSBBRl9JTkVUOgogCQlpZiAo
YWRkcmxlbiA8IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW4pKQogCQkJcmV0dXJuIC1FSU5W
QUw7CisKIAkJcmV0dXJuIDA7CiAjaWYgSVNfRU5BQkxFRChDT05GSUdfSVBWNikKIAljYXNl
IEFGX0lORVQ2OgogCQlpZiAoYWRkcmxlbiA8IFNJTjZfTEVOX1JGQzIxMzMpCiAJCQlyZXR1
cm4gLUVJTlZBTDsKKwogCQlyZXR1cm4gMDsKICNlbmRpZgogCX0KQEAgLTgxLDcgKzg2LDcg
QEAgc3RhdGljIGludCBjaGVja19hZGRybGVuKGNvbnN0IHN0cnVjdCBzb2NrYWRkciAqY29u
c3QgYWRkcmVzcywgaW50IGFkZHJsZW4pCiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyB1MTYg
Z2V0X3BvcnQoY29uc3Qgc3RydWN0IHNvY2thZGRyICpjb25zdCBhZGRyZXNzKQorc3RhdGlj
IF9fYmUxNiBnZXRfcG9ydChjb25zdCBzdHJ1Y3Qgc29ja2FkZHIgKmNvbnN0IGFkZHJlc3Mp
CiB7CiAJLyogR2V0cyBwb3J0IHZhbHVlIGluIGhvc3QgYnl0ZSBvcmRlci4gKi8KIAlzd2l0
Y2ggKGFkZHJlc3MtPnNhX2ZhbWlseSkgewpAQCAtODksMTMgKzk0LDEzIEBAIHN0YXRpYyB1
MTYgZ2V0X3BvcnQoY29uc3Qgc3RydWN0IHNvY2thZGRyICpjb25zdCBhZGRyZXNzKQogCWNh
c2UgQUZfSU5FVDogewogCQljb25zdCBzdHJ1Y3Qgc29ja2FkZHJfaW4gKmNvbnN0IHNvY2th
ZGRyID0KIAkJCShzdHJ1Y3Qgc29ja2FkZHJfaW4gKilhZGRyZXNzOwotCQlyZXR1cm4gbnRv
aHMoc29ja2FkZHItPnNpbl9wb3J0KTsKKwkJcmV0dXJuIHNvY2thZGRyLT5zaW5fcG9ydDsK
IAl9CiAjaWYgSVNfRU5BQkxFRChDT05GSUdfSVBWNikKIAljYXNlIEFGX0lORVQ2OiB7CiAJ
CWNvbnN0IHN0cnVjdCBzb2NrYWRkcl9pbjYgKmNvbnN0IHNvY2thZGRyX2lwNiA9CiAJCQko
c3RydWN0IHNvY2thZGRyX2luNiAqKWFkZHJlc3M7Ci0JCXJldHVybiBudG9ocyhzb2NrYWRk
cl9pcDYtPnNpbjZfcG9ydCk7CisJCXJldHVybiBzb2NrYWRkcl9pcDYtPnNpbjZfcG9ydDsK
IAl9CiAjZW5kaWYKIAl9CkBAIC0xMDMsMTYgKzEwOCwxOCBAQCBzdGF0aWMgdTE2IGdldF9w
b3J0KGNvbnN0IHN0cnVjdCBzb2NrYWRkciAqY29uc3QgYWRkcmVzcykKIAlyZXR1cm4gMDsK
IH0KIAotc3RhdGljIGludCBjaGVja19zb2NrZXRfYWNjZXNzKHN0cnVjdCBzb2NrZXQgKnNv
Y2ssIHN0cnVjdCBzb2NrYWRkciAqYWRkcmVzcywgaW50IGFkZHJsZW4sIHUxNiBwb3J0LAot
CQkJICAgICAgIGFjY2Vzc19tYXNrX3QgYWNjZXNzX3JlcXVlc3QpCitzdGF0aWMgaW50IGNo
ZWNrX3NvY2tldF9hY2Nlc3Moc3RydWN0IHNvY2tldCAqY29uc3Qgc29jaywKKwkJCSAgICAg
ICBzdHJ1Y3Qgc29ja2FkZHIgKmNvbnN0IGFkZHJlc3MsCisJCQkgICAgICAgY29uc3QgaW50
IGFkZHJsZW4sCisJCQkgICAgICAgY29uc3QgYWNjZXNzX21hc2tfdCBhY2Nlc3NfcmVxdWVz
dCkKIHsKLQlpbnQgcmV0OworCWludCBlcnI7CisJX19iZTE2IHBvcnQ7CiAJYm9vbCBhbGxv
d2VkID0gZmFsc2U7CiAJbGF5ZXJfbWFza190IGxheWVyX21hc2tzW0xBTkRMT0NLX05VTV9B
Q0NFU1NfTkVUXSA9IHt9OwogCWNvbnN0IHN0cnVjdCBsYW5kbG9ja19ydWxlICpydWxlOwog
CWFjY2Vzc19tYXNrX3QgaGFuZGxlZF9hY2Nlc3M7Ci0JY29uc3Qgc3RydWN0IGxhbmRsb2Nr
X2lkIGlkID0gewotCQkua2V5LmRhdGEgPSBwb3J0LAorCXN0cnVjdCBsYW5kbG9ja19pZCBp
ZCA9IHsKIAkJLnR5cGUgPSBMQU5ETE9DS19LRVlfTkVUX1BPUlQsCiAJfTsKIAljb25zdCBz
dHJ1Y3QgbGFuZGxvY2tfcnVsZXNldCAqY29uc3QgZG9tYWluID0gZ2V0X2N1cnJlbnRfbmV0
X2RvbWFpbigpOwpAQCAtMTIxLDEzICsxMjgsMjAgQEAgc3RhdGljIGludCBjaGVja19zb2Nr
ZXRfYWNjZXNzKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBzb2NrYWRkciAqYWRkcmVz
cywgaW4KIAkJcmV0dXJuIDA7CiAJaWYgKFdBUk5fT05fT05DRShkb21haW4tPm51bV9sYXll
cnMgPCAxKSkKIAkJcmV0dXJuIC1FQUNDRVM7Ci0JLyogQ2hlY2sgaWYgaXQncyBhIFRDUCBz
b2NrZXQuICovCisKKwkvKiBDaGVja3MgaWYgaXQncyBhIFRDUCBzb2NrZXQuICovCiAJaWYg
KHNvY2stPnR5cGUgIT0gU09DS19TVFJFQU0pCiAJCXJldHVybiAwOwogCi0JcmV0ID0gY2hl
Y2tfYWRkcmxlbihhZGRyZXNzLCBhZGRybGVuKTsKLQlpZiAocmV0KQotCQlyZXR1cm4gcmV0
OworCS8qIENoZWNrcyBmb3IgbWluaW1hbCBoZWFkZXIgbGVuZ3RoLiAqLworCWVyciA9IGNo
ZWNrX2FkZHJsZW4oYWRkcmVzcywgYWRkcmxlbik7CisJaWYgKGVycikKKwkJcmV0dXJuIGVy
cjsKKworCS8qIEl0IGlzIG5vdyBzYWZlIHRvIHJlYWQgdGhlIHBvcnQuICovCisJcG9ydCA9
IGdldF9wb3J0KGFkZHJlc3MpOworCWlkLmtleS5kYXRhID0gKF9fZm9yY2UgdWludHB0cl90
KXBvcnQ7CisJQlVJTERfQlVHX09OKHNpemVvZihwb3J0KSA+IHNpemVvZihpZC5rZXkuZGF0
YSkpOwogCiAJc3dpdGNoIChhZGRyZXNzLT5zYV9mYW1pbHkpIHsKIAljYXNlIEFGX1VOU1BF
QzoKQEAgLTE3MiwxNyArMTg2LDE4IEBAIHN0YXRpYyBpbnQgY2hlY2tfc29ja2V0X2FjY2Vz
cyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qgc29ja2FkZHIgKmFkZHJlc3MsIGluCiAJ
cmV0dXJuIGFsbG93ZWQgPyAwIDogLUVBQ0NFUzsKIH0KIAotc3RhdGljIGludCBob29rX3Nv
Y2tldF9iaW5kKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBzb2NrYWRkciAqYWRkcmVz
cywKLQkJCSAgICBpbnQgYWRkcmxlbikKK3N0YXRpYyBpbnQgaG9va19zb2NrZXRfYmluZChz
dHJ1Y3Qgc29ja2V0ICpjb25zdCBzb2NrLAorCQkJICAgIHN0cnVjdCBzb2NrYWRkciAqY29u
c3QgYWRkcmVzcywgY29uc3QgaW50IGFkZHJsZW4pCiB7Ci0JcmV0dXJuIGNoZWNrX3NvY2tl
dF9hY2Nlc3Moc29jaywgYWRkcmVzcywgYWRkcmxlbiwgZ2V0X3BvcnQoYWRkcmVzcyksCisJ
cmV0dXJuIGNoZWNrX3NvY2tldF9hY2Nlc3Moc29jaywgYWRkcmVzcywgYWRkcmxlbiwKIAkJ
CQkgICBMQU5ETE9DS19BQ0NFU1NfTkVUX0JJTkRfVENQKTsKIH0KIAotc3RhdGljIGludCBo
b29rX3NvY2tldF9jb25uZWN0KHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBzb2NrYWRk
ciAqYWRkcmVzcywKLQkJCSAgICAgICBpbnQgYWRkcmxlbikKK3N0YXRpYyBpbnQgaG9va19z
b2NrZXRfY29ubmVjdChzdHJ1Y3Qgc29ja2V0ICpjb25zdCBzb2NrLAorCQkJICAgICAgIHN0
cnVjdCBzb2NrYWRkciAqY29uc3QgYWRkcmVzcywKKwkJCSAgICAgICBjb25zdCBpbnQgYWRk
cmxlbikKIHsKLQlyZXR1cm4gY2hlY2tfc29ja2V0X2FjY2Vzcyhzb2NrLCBhZGRyZXNzLCBh
ZGRybGVuLCBnZXRfcG9ydChhZGRyZXNzKSwKKwlyZXR1cm4gY2hlY2tfc29ja2V0X2FjY2Vz
cyhzb2NrLCBhZGRyZXNzLCBhZGRybGVuLAogCQkJCSAgIExBTkRMT0NLX0FDQ0VTU19ORVRf
Q09OTkVDVF9UQ1ApOwogfQogCi0tIAoyLjM5LjAKCg==

--------------On0rNqP3BGAQZeC4daDmM00S--
