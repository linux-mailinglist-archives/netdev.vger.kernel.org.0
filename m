Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188D067D489
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjAZSoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAZSoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:44:24 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB806BB;
        Thu, 26 Jan 2023 10:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mh8ipCV8VjoxIYZIu67rp3FSPW2Sfioq7c+945zRJRo=; b=Xn/GEYV+M7tqZj0tVgKSErm0Gk
        pKYpFf/6ciuSHaDCGjNY4S6yVhGlhfzvxTawlA2UQXSuXVJa32OHBNWncgpgUl+SQDFz1pQUYZLlF
        rbEZioWxj7n1DRm4AEZI+m6oiMIiQ+nBNAACmGPS0CF6bZfCQu8G5AJl0NcwvTvBtthQ=;
Received: from p5b206403.dip0.t-ipconnect.de ([91.32.100.3] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pL7DX-002ctH-6H; Thu, 26 Jan 2023 19:43:23 +0100
Message-ID: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
Date:   Thu, 26 Jan 2023 19:43:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
References: <20230124124300.94886-1-nbd@nbd.name>
 <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
 <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
 <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
 <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
 <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name>
 <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
 <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name>
 <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
 <9992e7b5-7f2b-b79d-9c48-cf689807f185@nbd.name>
 <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
 <148028e75d720091caa56e8b0a89544723fda47e.camel@gmail.com>
 <8ec239d3-a005-8609-0724-f1042659791e@nbd.name>
 <8a331165-4435-4c2d-70e0-20655019dc51@nbd.name>
 <CAKgT0Ud8npNtncH-KbMtj_R=UZ=aFA9T8U=TZoLG_94eVUxKPA@mail.gmail.com>
 <bc0fa31a-c935-c6f0-f968-9e2a54bafd45@nbd.name>
 <156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.23 19:38, Alexander H Duyck wrote:
> Okay, I think that tells me exactly what is going on. Can you give the
> change below a try and see if it solves the problem for you.
> 
> I think what is happening is that after you are reassigning the frags
> they are getting merged into GRO frames where the head may have
> pp_recycle set. As a result I think the pages are getting recycled when
> they should be just freed via put_page.
> 
> I'm suspecting this wasn't an issue up until now as I don't believe
> there are any that are running in a mixed mode where they have both
> pp_recycle and non-pp_recycle skbs coming from the same device.
> 
> diff --git a/net/core/gro.c b/net/core/gro.c
> index 506f83d715f8..4bac7ea6e025 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct
> sk_buff *skb)
>   	struct sk_buff *lp;
>   	int segs;
>   
> +	/* Do not splice page pool based packets w/ non-page pool
> +	 * packets. This can result in reference count issues as page
> +	 * pool pages will not decrement the reference count and will
> +	 * instead be immediately returned to the pool or have frag
> +	 * count decremented.
> +	 */
> +	if (p->pp_recycle != skb->pp_recycle)
> +		return -ETOOMANYREFS;
> +
>   	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
>   	gro_max_size = READ_ONCE(p->dev->gro_max_size);
>   
That works, thanks!

- Felix
