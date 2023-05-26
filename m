Return-Path: <netdev+bounces-5817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1A0712E99
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 23:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36C451C210F7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B53829111;
	Fri, 26 May 2023 21:00:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396492CA9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 21:00:54 +0000 (UTC)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9F1D9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:00:52 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-52cb78647ecso778671a12.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685134852; x=1687726852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ysEB3TrSbfOrgA9FR4FkyBXy/5R3r970UROIlGdQbeM=;
        b=YyDaOhIzVZ5GWdlSNV5YF5iCNqGBU8gzhVHHQm4mhG/DAGqAKRL4mNA2ATxNfGkodP
         5n38novKPUqRNZRr+ZsFlMPguyFMsRysxa/MJgGETi4wxn4NBUT68K4Bzaboyb78TTkS
         GrLQwQafvFN1Xef1oehnbAzoKUicsYBPVA0u4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685134852; x=1687726852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysEB3TrSbfOrgA9FR4FkyBXy/5R3r970UROIlGdQbeM=;
        b=Am5qZsqM0XqIUrSIDwibeE++Wsp+tVE0NlW79yQZscNHl/xvvanuWjXhZW5+mXSoOa
         Kk8fvvpgMFiVlvFU1TDpvHDzWpv68vmtbK67LzcHf0lDZSZ8lyJsHjHYlwPJ7uePE8ZK
         Z3zR+CNveu1qD+fJcFxRvv+vDA5AIpTPpWi7if2qzr4k+ITreceSjGqigsa7c4IRxYvN
         p0xXp8t3XFxOIjdO4rDLpWe/FRYkZhE2zNoaR7CUoXJgOvtiwcs4+wwSwuEVj4As0ZYC
         kG7pj9gX9lYE6ocYFZXBWitxU5rBnxS2SCvDuggUGppH4xClNq1zivaCBjjBwPIcbTEj
         uyWw==
X-Gm-Message-State: AC+VfDycyhBoRGTSyzvQgNajbtTEqPjbALs/cH6oeXzTTMvFfvWWvikR
	J5lt8CFmfUCboPaMPgX2VfIPyw==
X-Google-Smtp-Source: ACHHUZ4/lR1eDBoUYP08CmKaLuvmX5MhsSXCw931slnptyNF8cayHqvMk/u2bmUX4fNNayenLkoT1w==
X-Received: by 2002:a05:6a21:999e:b0:10c:49e:6c67 with SMTP id ve30-20020a056a21999e00b0010c049e6c67mr744819pzb.33.1685134851856;
        Fri, 26 May 2023 14:00:51 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t4-20020aa79384000000b005aa60d8545esm3085995pfe.61.2023.05.26.14.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 14:00:51 -0700 (PDT)
Date: Fri, 26 May 2023 14:00:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	"Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: Re: [PATCH][next] iavf: Replace one-element array with
 flexible-array member
Message-ID: <202305261358.EA0ACE712@keescook>
References: <ZGLR3H1OTgJfOdFP@work>
 <692650e7-c006-4f89-3b11-dd2f193f510c@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692650e7-c006-4f89-3b11-dd2f193f510c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 11:19:00AM -0700, Tony Nguyen wrote:
> On 5/15/2023 5:44 PM, Gustavo A. R. Silva wrote:
> > One-element arrays are deprecated, and we are replacing them with flexible
> > array members instead. So, replace one-element array with flexible-array
> > member in struct iavf_qvlist_info, and refactor the rest of the code,
> > accordingly.
> > 
> > This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> > routines on memcpy() and help us make progress towards globally
> > enabling -fstrict-flex-arrays=3 [1].
> > 
> > Link: https://github.com/KSPP/linux/issues/79
> > Link: https://github.com/KSPP/linux/issues/289
> > Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >   drivers/net/ethernet/intel/iavf/iavf_client.c | 2 +-
> >   drivers/net/ethernet/intel/iavf/iavf_client.h | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
> > index 93c903c02c64..782384b3aa38 100644
> > --- a/drivers/net/ethernet/intel/iavf/iavf_client.c
> > +++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
> > @@ -470,7 +470,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
> >   	v_qvlist_info = (struct virtchnl_rdma_qvlist_info *)qvlist_info;
> >   	msg_size = struct_size(v_qvlist_info, qv_info,
> > -			       v_qvlist_info->num_vectors - 1);
> > +			       v_qvlist_info->num_vectors);
> 
> The problem is this mirrors the virtchnl struct (virtchnl_rdma_qvlist_info)
> so that structure needs to change as well... However, this goes back to the
> interface that virtchnl provides between PF and VF [1].
> 
> I think removing the iavf structure and directly using the virtchnl one
> would make sense. We'd need to adjust virtchnl and follow Kees' suggestion
> [2].

Note that at the time I suggested "[0]", but it should have been
"[]". But, yes, Keeping the "over allocation" is fine since it's a
hardware ABI.

Alternatively, it could be defined with a union to keep all the sizes
the same:

 struct iavf_qvlist_info {
 	u32 num_vectors;
-	struct iavf_qv_info qv_info[1];
+	union {
+		struct iavf_qv_info single_qv_info;
+		DECLARE_FLEX_ARRAY(struct iavf_qv_info, qv_info)
+	};
 };

-Kees

> 
> >   	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP);
> >   	err = iavf_aq_send_msg_to_pf(&adapter->hw,
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.h b/drivers/net/ethernet/intel/iavf/iavf_client.h
> > index c5d51d7dc7cc..500269bc0f5b 100644
> > --- a/drivers/net/ethernet/intel/iavf/iavf_client.h
> > +++ b/drivers/net/ethernet/intel/iavf/iavf_client.h
> > @@ -53,7 +53,7 @@ struct iavf_qv_info {
> >   struct iavf_qvlist_info {
> >   	u32 num_vectors;
> > -	struct iavf_qv_info qv_info[1];
> > +	struct iavf_qv_info qv_info[];
> >   };
> >   #define IAVF_CLIENT_MSIX_ALL 0xFFFFFFFF
> 
> [1] https://lore.kernel.org/intel-wired-lan/f3674339c0390ced22b365101f2d3e3a2bf26845.camel@intel.com/
> [2] https://lore.kernel.org/intel-wired-lan/202106091424.37E833794@keescook/

-- 
Kees Cook

