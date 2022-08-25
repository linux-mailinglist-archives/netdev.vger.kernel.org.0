Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39FC5A15D6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiHYPcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242851AbiHYPbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:31:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2408A74353;
        Thu, 25 Aug 2022 08:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F135E61AB3;
        Thu, 25 Aug 2022 15:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1DAC433C1;
        Thu, 25 Aug 2022 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661441503;
        bh=T11/F7BgE239LRXHDyNOIUVXHmxFBP7bP1coH5+n/sE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Pjhzv2oa3PwImoti6yU7jeDOfwVqlBMIFN4PYUzMz9WRHhJ98kn6+wlfMfgC2Tk3F
         O8nwqpVNJtZtF4EBE1OudRwjzAA28z+Jmfvzt8+3bQorejZcd16iGpQRapgHfxm6hF
         WXOYB2olpWvcJuR1uMm6PATb47ACaX8+e621jnzkRmshyp3BPpp2EoTOvj3Q7Rr9tf
         Hj3uxTJg5mEXUqAKi4v/CoH+AR8ya/XJn16+HYuoS1IofkJUM0TWhgaw5au62FypxY
         mBz5EzU1M68Q0SOqTei9X2De0GbfxELvQeRx9owQh80mD+g/VUuN0QFSJFcdzPM+nJ
         xxcBt0i8wAFdQ==
Message-ID: <97dc2f1d-081e-a182-cc4d-57e3df4742a0@kernel.org>
Date:   Thu, 25 Aug 2022 08:31:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-9-dima@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220818170005.747015-9-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 9:59 AM, Dmitry Safonov wrote:
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 849bbf2d3c38..5369458ae89f 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -129,6 +129,9 @@ enum {
>  
>  #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
>  
> +#define TCP_AO			38	/* (Add/Set MKT) */
> +#define TCP_AO_DEL		39	/* (Delete MKT) */
> +#define TCP_AO_MOD		40	/* (Modify MKT) */
>  
>  #define TCP_REPAIR_ON		1
>  #define TCP_REPAIR_OFF		0
> @@ -344,6 +347,38 @@ struct tcp_diag_md5sig {
>  
>  #define TCP_AO_MAXKEYLEN	80
>  
> +#define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
> +#define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
> +
> +struct tcp_ao { /* setsockopt(TCP_AO) */
> +	struct __kernel_sockaddr_storage tcpa_addr;
> +	char	tcpa_alg_name[64];
> +	__u16	tcpa_flags;
> +	__u8	tcpa_prefix;
> +	__u8	tcpa_sndid;
> +	__u8	tcpa_rcvid;
> +	__u8	tcpa_maclen;
> +	__u8	tcpa_keyflags;
> +	__u8	tcpa_keylen;
> +	__u8	tcpa_key[TCP_AO_MAXKEYLEN];
> +} __attribute__((aligned(8)));
> +
> +struct tcp_ao_del { /* setsockopt(TCP_AO_DEL) */
> +	struct __kernel_sockaddr_storage tcpa_addr;
> +	__u16	tcpa_flags;
> +	__u8	tcpa_prefix;
> +	__u8	tcpa_sndid;
> +	__u8	tcpa_rcvid;
> +	__u8	tcpa_current;
> +	__u8	tcpa_rnext;
> +} __attribute__((aligned(8)));
> +
> +struct tcp_ao_mod { /* setsockopt(TCP_AO_MOD) */
> +	__u16	tcpa_flags;
> +	__u8	tcpa_current;
> +	__u8	tcpa_rnext;
> +} __attribute__((aligned(8)));
> +
>  /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
>  
>  #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1


I do not see anything in the uapi that would specify the VRF for the
address.

