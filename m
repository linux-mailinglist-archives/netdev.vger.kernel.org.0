Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F05B14B9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 08:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIHGgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 02:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIHGgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 02:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350E6C0BCF
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 23:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662618959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6satdqBnzaWL+j8s1zSOLKz7gVaAnF4gDLw4Fs5Ro4A=;
        b=BzaxpKre82RbjL19WIRbco/NQv1yVwv3CuNBLJhdTnJzXcFkhGv7WcHpD8hq62M1GYexX9
        kD3M055HgG9RKCtXTL62F6r4qwD28KExUz9p7a/Dl6nlJ71BOf0jNFbqEdJg+tdA+oy3be
        f+EkYUGWw3GkYTtMxdARLYtXbEjysL4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-r3SE2ZHDOCyGiWfr1U3TsQ-1; Thu, 08 Sep 2022 02:35:58 -0400
X-MC-Unique: r3SE2ZHDOCyGiWfr1U3TsQ-1
Received: by mail-wm1-f69.google.com with SMTP id c25-20020a05600c0ad900b003a5ebad295aso167139wmr.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 23:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=6satdqBnzaWL+j8s1zSOLKz7gVaAnF4gDLw4Fs5Ro4A=;
        b=RKPLcX6e0MenlbGIG0oJSjmTiXqxl0pFMypcwDG5KgjJOBlQCyDEYl32lGRW/KVRaw
         Fs5XnQz6aqa+m67UtNsXesXVofQjDRkALlgL5pQycYFFry3dTEnyi/od87/xTRaF9+Ag
         XeIO0YveYP+ZsRe4gW8VWACdMKX1UBn6wOR8oYF/4/rG7Tlc/ndEPJw/yjK1+ew+KZok
         DKdW42E9lzrq0oVAuljV/4AHlf/wCTfzLXPoG1lOya7C+FLMGyvjLRcEXjQditAyOFF1
         ULvW/efucHKgMbeoao1NnxJMpr21D7tSA5zGYtURRIeB8Ws2CnCPm3to11i3Bhrmscny
         aNwQ==
X-Gm-Message-State: ACgBeo2fmtQw7qLJarwmSOKgTBa3Jf2BycIeoOtvSrsDNT0QeHa7OGu2
        d5ZYggKZYAp4N994uNqjZiHdjphvHI6pN/SO+Eh1aOM2qDH0CZ81bQTTXnOaE2j2BfA+9hPHMpQ
        OwmoeGk4mnzGCGSjt
X-Received: by 2002:a1c:f70e:0:b0:3a6:8c16:93a2 with SMTP id v14-20020a1cf70e000000b003a68c1693a2mr1051232wmh.184.1662618957344;
        Wed, 07 Sep 2022 23:35:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4fc55aVw7fMNN37BscplwkSkD0HqrZDKNz9AuWXAC84228ec7akcGGmdT7pdRPk0uD5uXIIQ==
X-Received: by 2002:a1c:f70e:0:b0:3a6:8c16:93a2 with SMTP id v14-20020a1cf70e000000b003a68c1693a2mr1051213wmh.184.1662618957125;
        Wed, 07 Sep 2022 23:35:57 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600c1d1000b003a30fbde91dsm1704892wms.20.2022.09.07.23.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 23:35:56 -0700 (PDT)
Message-ID: <9bb98d13313d2ebeb5804d67285e8e6320ce4e74.camel@redhat.com>
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key
 management
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 08 Sep 2022 08:35:55 +0200
In-Reply-To: <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
         <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 10:05 +0300, Leonard Crestez wrote:
[...]
> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
> new file mode 100644
> index 000000000000..d38e9c89c89d
> --- /dev/null
> +++ b/net/ipv4/tcp_authopt.c
> @@ -0,0 +1,317 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <net/tcp_authopt.h>
> +#include <net/ipv6.h>
> +#include <net/tcp.h>
> +#include <linux/kref.h>
> +
> +/* This is enabled when first struct tcp_authopt_info is allocated and never released */
> +DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
> +EXPORT_SYMBOL(tcp_authopt_needed_key);
> +
> +static inline struct netns_tcp_authopt *sock_net_tcp_authopt(const struct sock *sk)
> +{
> +	return &sock_net(sk)->tcp_authopt;
> +}

Please have a look at PW report for this series, there are a bunch of
issues to be addressed, e.g. above 'static inline' should be just
'static'


> +
> +static void tcp_authopt_key_release_kref(struct kref *ref)
> +{
> +	struct tcp_authopt_key_info *key = container_of(ref, struct tcp_authopt_key_info, ref);
> +
> +	kfree_rcu(key, rcu);
> +}
> +
> +static void tcp_authopt_key_put(struct tcp_authopt_key_info *key)
> +{
> +	if (key)
> +		kref_put(&key->ref, tcp_authopt_key_release_kref);
> +}
> +
> +static void tcp_authopt_key_del(struct netns_tcp_authopt *net,
> +				struct tcp_authopt_key_info *key)
> +{
> +	lockdep_assert_held(&net->mutex);
> +	hlist_del_rcu(&key->node);
> +	key->flags |= TCP_AUTHOPT_KEY_DEL;
> +	kref_put(&key->ref, tcp_authopt_key_release_kref);
> +}
> +
> +/* Free info and keys.
> + * Don't touch tp->authopt_info, it might not even be assigned yes.
> + */
> +void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)

this need to be 'static'.

I'm sorry to bring the next topic this late (If already discussed, I
missed that point), is possible to split this series in smaller chunks?


Cheers,

Paolo

