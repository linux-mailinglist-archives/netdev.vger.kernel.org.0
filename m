Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390AC598403
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244983AbiHRNWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiHRNWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:22:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51558B02BE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:22:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fy5so3236912ejc.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=M6twNLDdiAyqijRujWv+jTZ/HkYbrPlBRR42YrvjkjY=;
        b=g/Y7R8gntw8Hr1VOzIKddVDRq7c0csGngBk+2mFJNQOFR5vdrU9Iov9GaBWVkSjZaU
         xlBrNgb/v3iH93zJjeopGoWpZmWJxltMpcrWmHI5/jVjZmOWfd3+fV3WqWBkQwYXn1r3
         mbTUJQ/DRtWpWd6c4r9R5xJGgNwHZK+wVNRHC/SQ6dKEqHCixlCRb/Kjm9HgDr2pvt0a
         UxTj2KvftEinpclnghSxYPa/OrAyGCwwHGQOlt++A1monPzyyMkzRL0He1Mroyc7um4b
         tQMdHiFzW2ogAkHiCZMRFz+Zt+y6swnFwAIDbFuSkm1kbuBVeU8LowyvF65kLECTCI1V
         +3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=M6twNLDdiAyqijRujWv+jTZ/HkYbrPlBRR42YrvjkjY=;
        b=OkFwJliqJt6eyvgmmR9nvVENrCUZa4VB5jYFkV4uqXBwzmq/Pk7VPTdT1KJ9qdBKnO
         b5JmC+CYs3x3j9bxRiVMRWTbWJ07qzxhp6QOv3VUARdKhpoOKUK6jKvk7wrr0/Bxxixt
         B4+l/WwsR+yxhOU5ttTzGsQl0/d8TkAGfOkP3DcS+GkPAL40Zp3HfB2PDMRgxBKIoGwi
         rh0msyZzb9/sjRcTTGJrge0rXL8ej3FW591slam6c20cXaQhugGxfWFyEEjL5PkgVw2F
         eTW/Z9xgoQDA7GhXHfKC5qaM8N8OYYSGFZQxmDjKemdDBoKdQaXYMviJoqojEYSvGfNt
         xpyw==
X-Gm-Message-State: ACgBeo1Zrwv9+a3VEvz2bXtNSD2VztIln8hTH+SvrwDQS/RLrW+BqUsn
        Azqe/pVbwRGM//hsmSwH3vw=
X-Google-Smtp-Source: AA6agR6TJCRyPHrVTHIVHom/5b7ETg1N+HX3gnNp1USgtRSIKB/QG49+f8rzqj1ecYW37cyLNzCU6g==
X-Received: by 2002:a17:907:2cd1:b0:730:65c9:4c18 with SMTP id hg17-20020a1709072cd100b0073065c94c18mr1910878ejc.324.1660828941806;
        Thu, 18 Aug 2022 06:22:21 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id w23-20020aa7cb57000000b0043ba0cf5dbasm1180064edt.2.2022.08.18.06.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 06:22:21 -0700 (PDT)
Subject: Re: [PATCH v2 net 15/17] net: Fix a data-race around
 gro_normal_batch.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>
References: <20220818035227.81567-1-kuniyu@amazon.com>
 <20220818035227.81567-16-kuniyu@amazon.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <c1c2a430-85f8-5d83-6837-fe3ce3579ad7@gmail.com>
Date:   Thu, 18 Aug 2022 14:22:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220818035227.81567-16-kuniyu@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 04:52, Kuniyuki Iwashima wrote:
> While reading gro_normal_batch, it can be changed concurrently.
> Thus, we need to add READ_ONCE() to its reader.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> CC: Edward Cree <ecree@solarflare.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
>  include/net/gro.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 867656b0739c..24003dea8fa4 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -439,7 +439,7 @@ static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb,
>  {
>  	list_add_tail(&skb->list, &napi->rx_list);
>  	napi->rx_count += segs;
> -	if (napi->rx_count >= gro_normal_batch)
> +	if (napi->rx_count >= READ_ONCE(gro_normal_batch))
>  		gro_normal_list(napi);
>  }
>  
> 

