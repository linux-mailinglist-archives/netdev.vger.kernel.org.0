Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E95776A4
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiGQOTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiGQOTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:19:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8EB06387
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658067542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXN5d9PmR1bWxOtQJJuDS0yvq9ORJNM/o9bv7t0FtfM=;
        b=Jvp2QVBuF+2Cy7l6YQ0bCdBD4VRcPSZKIvpZI8s+2e+KkemHxpw2FdQSSMV96yBAGrxfaz
        6eo6cG4bTM17YlSpQ4McJmia3oPz17ycmJQfZfxhA2cnpPA+exuJGOKXUyuRF19NQkJmqW
        2MGpPDpEs1L/jSC8PpdEJkjNEQ5A4BY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-H0V9sZ6AMKK0eZ2oMILWFg-1; Sun, 17 Jul 2022 10:19:01 -0400
X-MC-Unique: H0V9sZ6AMKK0eZ2oMILWFg-1
Received: by mail-wr1-f69.google.com with SMTP id t28-20020adfa2dc000000b0021df4601013so239549wra.14
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZXN5d9PmR1bWxOtQJJuDS0yvq9ORJNM/o9bv7t0FtfM=;
        b=e4iVrPiP1xtCNPM/sslcRUa5Sau/Mfjlz/3lPrfaGXGk61k/keDCotD7g7+WsDV+1w
         t7+DMbMzD47aBOZgcXf3anx43lWD6nmWR14X/tHhHOSjr5cOVvtsFlrO0wPrAYqTCSM8
         cmxAQaoWLAZ69stIslawmelboB0Gw4tNkZKxM4lUDBE8y5loHXUCJofia3/40wjCsCeA
         cTFXXZqxfcj8GgpN7bEHD95Oubn4JWx58QXkNC5NYp449pLOlWzRiV94QfpAzznMIkuc
         jlgzI9C4frTOXVM6gJ+f1GI6T5Lxgp9QvWoJagFmDLH3N1ALN7A7HEgR8/NpAVIgYWYT
         k0Og==
X-Gm-Message-State: AJIora8TboZDktGRHx4d1nG+Hk1f1BMXQwHqS2JyKwC7+jf1erbDhHGc
        GxxK4xHrnM8CNY8cWx+1e10lOHU6KeJHa2KL3Ih9RCbJPEO4s3eTk3LUNiUkGmasG9iW7ZRVZ7g
        8nst/XT6DTmF16Sew
X-Received: by 2002:a5d:4b87:0:b0:21d:7019:80c6 with SMTP id b7-20020a5d4b87000000b0021d701980c6mr19219070wrt.234.1658067540015;
        Sun, 17 Jul 2022 07:19:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNaEvKbutpZ/BTubwQTUJVx19iGzoNuTHgO/zaFD31SqJMlb5VplfxKgnDPMz9VTFHe9C5rg==
X-Received: by 2002:a5d:4b87:0:b0:21d:7019:80c6 with SMTP id b7-20020a5d4b87000000b0021d701980c6mr19219051wrt.234.1658067539794;
        Sun, 17 Jul 2022 07:18:59 -0700 (PDT)
Received: from localhost.localdomain ([185.233.130.50])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d5382000000b0021d7122ab80sm8264967wrv.110.2022.07.17.07.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 07:18:59 -0700 (PDT)
Date:   Sun, 17 Jul 2022 16:18:56 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@speakeasy.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v5 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220717141856.GB3118@localhost.localdomain>
References: <20220715130430.160029-1-marcin.szycik@linux.intel.com>
 <20220715130430.160029-2-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715130430.160029-2-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 03:04:27PM +0200, Marcin Szycik wrote:
> +/**
> + * is_ppp_proto_supported - checks if inner PPP protocol should be dissected
> + * @proto: protocol type (PPP proto field)
> + */
> +static bool is_ppp_proto_supported(__be16 proto)
> +{
> +	switch (proto) {
> +	case htons(PPP_AT):
> +	case htons(PPP_IPX):
> +	case htons(PPP_VJC_COMP):
> +	case htons(PPP_VJC_UNCOMP):
> +	case htons(PPP_MP):
> +	case htons(PPP_COMPFRAG):
> +	case htons(PPP_COMP):
> +	case htons(PPP_IPCP):
> +	case htons(PPP_ATCP):
> +	case htons(PPP_IPXCP):
> +	case htons(PPP_IPV6CP):
> +	case htons(PPP_CCPFRAG):
> +	case htons(PPP_MPLSCP):
> +	case htons(PPP_LCP):
> +	case htons(PPP_PAP):
> +	case htons(PPP_LQR):
> +	case htons(PPP_CHAP):
> +	case htons(PPP_CBCP):
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

The more I think about it, the more I believe we should make this
function more generic by following the Protocol field definition found
in section 2 of RFC 1661:
https://datatracker.ietf.org/doc/html/rfc1661#section-2

I mean, it's very surprising that is_ppp_proto_supported() returns
false for protocols like PPP_IP or PPP_IPV6, which certainly are
supported. Of course, in the context of your patch, PPP_IP and PPP_IPV6
have been tested first, but that makes the code a bit unclear.

We could define a simpler and more generic helper function (probably in
a ppp header file). Something like (unstested):

/* Assumes proto isn't compressed. */
static bool ppp_proto_is_valid(u16 proto) /*
{
	/* Protocol must be odd and the least significant bit of the
	 * most significant octet must be 0 (see RFC 1661, section 2).
	 */
	return !!(proto & 0X0101 == 0x0001)
}

BTW, we don't have to restrict the list of supported protocols to the
PPP_* numbers defined in the kernel as we have no indication that the PPP
frame is going to be handled locally.

> +static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
> +{
> +	return hdr.ver == 1 && hdr.type == 1 && hdr.code == 0;
> +}
> +
>  /**
>   * __skb_flow_dissect - extract the flow_keys struct and return it
>   * @net: associated network namespace, derived from @skb if NULL
> @@ -1214,26 +1250,61 @@ bool __skb_flow_dissect(const struct net *net,
>  			struct pppoe_hdr hdr;
>  			__be16 proto;
>  		} *hdr, _hdr;
> +		u16 ppp_proto;
> +
>  		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
>  		if (!hdr) {
>  			fdret = FLOW_DISSECT_RET_OUT_BAD;
>  			break;
>  		}
>  
> -		nhoff += PPPOE_SES_HLEN;
> -		switch (hdr->proto) {
> -		case htons(PPP_IP):
> +		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
> +			fdret = FLOW_DISSECT_RET_OUT_BAD;
> +			break;
> +		}
> +
> +		/* least significant bit of the least significant octet

That's the least significant bit of the _most significant_ octet (the
one of the least significant octet must always be 1).

> +		 * indicates if protocol field was compressed
> +		 */
> +		ppp_proto = ntohs(hdr->proto);
> +		if (ppp_proto & 256) {

Using hex would improve readability in my opinion (that is,
s/256/0x0100/).

> +			ppp_proto = htons(ppp_proto >> 8);

I don't get why you convert ppp_proto back to network byte order.
That contradicts the type annotation (u16).

> +			nhoff += PPPOE_SES_HLEN - 1;
> +		} else {
> +			ppp_proto = htons(ppp_proto);

Same here. We could leave ppp_proto untouched in this branch.

> +			nhoff += PPPOE_SES_HLEN;
> +		}
> +
> +		if (ppp_proto == htons(PPP_IP)) {

With ppp_proto kept in host byte order, the htons() call would need to
go.

>  			proto = htons(ETH_P_IP);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;
> -		case htons(PPP_IPV6):
> +		} else if (ppp_proto == htons(PPP_IPV6)) {

Same here, and in the following 'if' branches.

>  			proto = htons(ETH_P_IPV6);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;
> -		default:
> +		} else if (ppp_proto == htons(PPP_MPLS_UC)) {
> +			proto = htons(ETH_P_MPLS_UC);
> +			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> +		} else if (ppp_proto == htons(PPP_MPLS_MC)) {
> +			proto = htons(ETH_P_MPLS_MC);
> +			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> +		} else if (is_ppp_proto_supported(ppp_proto)) {
> +			fdret = FLOW_DISSECT_RET_OUT_GOOD;
> +		} else {
>  			fdret = FLOW_DISSECT_RET_OUT_BAD;
>  			break;
>  		}
> +
> +		if (dissector_uses_key(flow_dissector,
> +				       FLOW_DISSECTOR_KEY_PPPOE)) {
> +			struct flow_dissector_key_pppoe *key_pppoe;
> +
> +			key_pppoe = skb_flow_dissector_target(flow_dissector,
> +							      FLOW_DISSECTOR_KEY_PPPOE,
> +							      target_container);
> +			key_pppoe->session_id = hdr->hdr.sid;
> +			key_pppoe->ppp_proto = ppp_proto;

With ppp_proto being u16, we'd now need to call htons(ppp_proto).

> +			key_pppoe->type = htons(ETH_P_PPP_SES);
> +		}
>  		break;
>  	}
>  	case htons(ETH_P_TIPC): {
> -- 
> 2.35.1
> 

