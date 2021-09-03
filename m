Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772E7400139
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 16:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349431AbhICO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 10:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbhICO1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 10:27:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA223C061575;
        Fri,  3 Sep 2021 07:26:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id mf2so12432879ejb.9;
        Fri, 03 Sep 2021 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7OhriFlxLT8uxFxwaNtPhetPuz6ZequfBC1lDnC85e4=;
        b=SeqgDFSqq4pneESQjKI67NFfOjxtiltgyc/1XpP5d9KLWuYPqjAWXeTMyqqhxFm4FQ
         r94gaSXYBcctEMBOspnFTVtZr3mVP3doOfs+5n2oFWWjOQVdFnntjdW1u9jrp/5Z/ETn
         c1ZXlQy0qZHBti4zhxXJOStLl0HtOARenkIauJw9U0Jb6E1U8Y40z4uWJIc4ybXpoxlO
         f+enprTa6EB1DxTXwy03yDEgR/hwPCBSqU4/AeVPnWvtWx544qAAk5yO57KL7AVbnKN4
         MeqHvQ4fifS7IEsyiOu8WA3YzXkhpCNLy5ftvkoQxTzaOijwiqpZKTfZvb472kn17425
         bruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7OhriFlxLT8uxFxwaNtPhetPuz6ZequfBC1lDnC85e4=;
        b=GtDR+KKtwY3+uMOz36ggrIutTJ0CO4dQOyeyiCeSUyXf0oykShoheTITaiZ8L8wjNY
         r4+xYM7zvZk3Is68lds9v8nst09UP0LqA1/zRI8cj6q3dsmhNv2xkZ3r8VG0KSySxLhp
         5AUNLrIlY/xux1mxWJAuuC8p+CYwC/utCPAKWE4VLcXA2et0rKzmo3iEMymiQ/EEK7KJ
         0QDcKZxPMjMPxnP+5WpkGOHk3m87qEeBgL4ksM0EVyKFh/hg0ZRsc+xFWsCwshcoXTUr
         PIzS6qDD7K2g9ZKnrAtEL900w8ZPRwTMPyPsTbG+cqZxDfOlqXe8vcEeCyGn/+gBQsdx
         9DnQ==
X-Gm-Message-State: AOAM532hwoVer3xnPRzRgV2sWSCU4LnrS/dVdj+DXEpOWBHlt494/7vl
        eeZEkoTBpuiRTsL7CwZOo9CRfrdMQAhrjO3z
X-Google-Smtp-Source: ABdhPJw0gN3ZPx1pPTYSJ81JA1JNhNpphg0x7F9WE+zNb69V1QfTH1pQa8Wlxu695RplN+VZBfrVYg==
X-Received: by 2002:a17:907:ea1:: with SMTP id ho33mr4459523ejc.271.1630679210375;
        Fri, 03 Sep 2021 07:26:50 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:283d:84d1:f625:2914? ([2a04:241e:502:1d80:283d:84d1:f625:2914])
        by smtp.gmail.com with ESMTPSA id p23sm3295444edw.94.2021.09.03.07.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 07:26:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv3 01/15] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <090898ac6f3345ec02999858c65c2ebb8cd274a8.1629840814.git.cdleonard@gmail.com>
 <b93d21fa-13aa-20d9-0747-c443ccf2c5d5@gmail.com>
Message-ID: <5c7dbf82-b176-dd95-4fd4-dd1ee69d962d@gmail.com>
Date:   Fri, 3 Sep 2021 17:26:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b93d21fa-13aa-20d9-0747-c443ccf2c5d5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.08.2021 22:04, Dmitry Safonov wrote:
> Hi Leonard,
> On 8/24/21 10:34 PM, Leonard Crestez wrote:
>> +/**
>> + * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
>> + *
>> + * Key structure lifetime is only protected by RCU so readers needs to hold a
>> + * single rcu_read_lock until they're done with the key.
>> + */
>> +struct tcp_authopt_key_info {
>> +	struct hlist_node node;
>> +	struct rcu_head rcu;
>> +	/* Local identifier */
>> +	u32 local_id;
> 
> It's unused now, can be removed.

Yes

>> +/**
>> + * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
>> + *
>> + * @TCP_AUTHOPT_KEY_DEL: Delete the key by local_id and ignore all other fields.
>                                                ^
> By send_id and recv_id.

Yes. The identifying fields are documented on struct tcp_authopt_key so 
I will abbreviate this.

> Also, tcp_authopt_key_match_exact() seems to check
> TCP_AUTHOPT_KEY_ADDR_BIND. I wounder if that makes sense to relax it in
> case of TCP_AUTHOPT_KEY_DEL to match only send_id/recv_id if addr isn't
> specified (no hard feelings about it, though).

Same send_id/recv_id can overlap between different remote peers.

> [..]
>> +#ifdef CONFIG_TCP_AUTHOPT
>> +	case TCP_AUTHOPT: {
>> +		struct tcp_authopt info;
>> +
>> +		if (get_user(len, optlen))
>> +			return -EFAULT;
>> +
>> +		lock_sock(sk);
>> +		tcp_get_authopt_val(sk, &info);
>> +		release_sock(sk);
>> +
>> +		len = min_t(unsigned int, len, sizeof(info));
>> +		if (put_user(len, optlen))
>> +			return -EFAULT;
>> +		if (copy_to_user(optval, &info, len))
>> +			return -EFAULT;
>> +		return 0;
> 
> Failed tcp_get_authopt_val() lookup in:
> :       if (!info)
> :               return -EINVAL;
> 
> will leak uninitialized kernel memory from stack.
> ASLR guys defeated.

tcp_get_authopt_val clears *info before all checks so this will return 
zeros to userspace.

I do need to propagate the return value from tcp_get_authopt_val.

>> +#define TCP_AUTHOPT_KNOWN_FLAGS ( \
>> +	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
>> +
>> +int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
>> +	struct tcp_authopt opt;
>> +	struct tcp_authopt_info *info;
>> +
>> +	sock_owned_by_me(sk);
>> +
>> +	/* If userspace optlen is too short fill the rest with zeros */
>> +	if (optlen > sizeof(opt))
>> +		return -EINVAL;
> 
> More like
> :	if (unlikely(len > sizeof(opt))) {
> :		err = check_zeroed_user(optval + sizeof(opt),
> :					len - sizeof(opt));
> :		if (err < 1)
> :			return err == 0 ? -EINVAL : err;
> :		len = sizeof(opt);
> :		if (put_user(len, optlen))
> :			return -EFAULT;
> :	}

If (optlen > sizeof(opt)) means userspace is attempting to use newer 
ABI. Current behavior is to return an error which seems very reasonable.

You seem to be suggesting that we check that the rest of option is 
zeroes and if it is to continue. That seems potentially dangerous but it 
could work if we forever ensure that zeroes always mean "no effect".

This would make it easier for new apps to run on old kernels: unless 
they specifically use new features they don't need to do anything.

Also, setsockopt can't report a new length back and there's no 
getsockopt for keys.

>> +	memset(&opt, 0, sizeof(opt));
>> +	if (copy_from_sockptr(&opt, optval, optlen))
>> +		return -EFAULT;
>> +
>> +	if (opt.flags & ~TCP_AUTHOPT_KNOWN_FLAGS)
>> +		return -EINVAL;

Here if the user requests unrecognized flags an error is reported. My 
intention is that new fields will be accompanied by new flags.

>> +	info = __tcp_authopt_info_get_or_create(sk);
>> +	if (IS_ERR(info))
>> +		return PTR_ERR(info);
>> +
>> +	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
>> +
>> +	return 0;
>> +}
> 
> [..]
>> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
>> +	struct tcp_authopt_key opt;
>> +	struct tcp_authopt_info *info;
>> +	struct tcp_authopt_key_info *key_info;
>> +
>> +	sock_owned_by_me(sk);
>> +
>> +	/* If userspace optlen is too short fill the rest with zeros */
>> +	if (optlen > sizeof(opt))
>> +		return -EINVAL;
> 
> Ditto
> 
>> +	memset(&opt, 0, sizeof(opt));
>> +	if (copy_from_sockptr(&opt, optval, optlen))
>> +		return -EFAULT;
>> +
>> +	if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
>> +		return -EINVAL;
>> +
>> +	if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
>> +		return -EINVAL;
>> +
>> +	/* Delete is a special case: */
>> +	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
>> +		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
>> +		if (!info)
>> +			return -ENOENT;
>> +		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
>> +		if (!key_info)
>> +			return -ENOENT;
>> +		tcp_authopt_key_del(sk, info, key_info);
> 
> Doesn't seem to be safe together with tcp_authopt_select_key().
> A key can be in use at this moment - you have to add checks for it.

tcp_authopt_key_del does kfree_rcu. As far as I understand this means 
that if select_key can see the key it is guaranteed to live until the 
next grace period, which shouldn't be until after the packet is signed.

I will attempt to document this restriction on tcp_authopt_select_key: 
you can't do anything with the key except give it to tcp_authopt_hash 
before an RCU grace period.

I'm not confident this is correct in all cases. It's inspired by what 
MD5 does but apparently those key lists are protected by a combination 
of sk_lock and rcu?

>> +		return 0;
>> +	}
>> +
>> +	/* check key family */
>> +	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
>> +		if (sk->sk_family != opt.addr.ss_family)
>> +			return -EINVAL;
>> +	}
>> +
>> +	/* Initialize tcp_authopt_info if not already set */
>> +	info = __tcp_authopt_info_get_or_create(sk);
>> +	if (IS_ERR(info))
>> +		return PTR_ERR(info);
>> +
>> +	/* If an old key exists with exact ID then remove and replace.
>> +	 * RCU-protected readers might observe both and pick any.
>> +	 */
>> +	key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
>> +	if (key_info)
>> +		tcp_authopt_key_del(sk, info, key_info);
>> +	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
>> +	if (!key_info)
>> +		return -ENOMEM;
> 
> So, you may end up without any key.

Moving the sock_kmalloc higher should fix this, there would be no effect 
on alloc failure.

> Also, replacing a key is not at all safe: you may receive old segments
> which you in turn will discard and reset the connection. >
> I think the limitation RFC puts on removing keys in use and replacing
> existing keys are actually reasonable. Probably, it'd be better to
> enforce "key in use => desired key is different (or key_outdated flag)
> => key not in use => key may be removed" life-cycle of MKT.

Userspace breaking its own connections seems fine, it can already do 
this in many ways.

If the current key is removed the kernel will just switch to another 
valid key. If no valid keys exist then I expect it will switch to 
unsigned packets which is possibly quite dangerous.

Maybe it should be possible to insert a "marker" key which just says 
"don't do any unsigned traffic with this peer"?

--
Regards,
Leonard
