Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF2A4C366B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbiBXUBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiBXUBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE472763F9;
        Thu, 24 Feb 2022 12:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3B91B82684;
        Thu, 24 Feb 2022 20:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6924C340E9;
        Thu, 24 Feb 2022 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645732840;
        bh=SQaeb0Kta1h/s7fQ+4T22hNjVzetgs4lJusjv4G1iW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aax4l6Htvnug8mbTTCX0X2rLTjQUq6JeR+ueffcTenNILwwCX0flGWbvC3gLcJ6tA
         LIh0hvw+Bbd4wOD+R8WWkcXInjD/9/0jYzDDCJgngg0AP70xSThZhi+xoRqNk2k57S
         CZRuK6sIXueEnpj9OiYbnawB7IF086gcluUXoeYhoLInJcsG3QP8kljM56vsMmO0nL
         /YS4U7y0DFUMJwrxWivKuA85OBpeIBAp3XuUSCNqMoGWt7d6xBjNGn0zesXPqr7gIX
         eMs+OPAknzWIlasB15qWJ+spE8ujhHQYTziWSeHJ7iJl0ihM5++9OEaRHnYQt8UNyK
         pgum76xmSyGAg==
Date:   Thu, 24 Feb 2022 14:08:39 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 4/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_connect_event
Message-ID: <20220224200839.GA1292927@embeddedor>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <8a0e347615a3516980fd8b6ad2dc4864a880613b.1645583264.git.gustavoars@kernel.org>
 <6106494b-a1b3-6b57-8b44-b9528127533b@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6106494b-a1b3-6b57-8b44-b9528127533b@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 04:50:18PM -0800, Jeff Johnson wrote:
> On 2/22/2022 6:38 PM, Gustavo A. R. Silva wrote:
> > Replace one-element array with flexible-array member in struct
> > wmi_connect_event.
> > 
> > It's also worth noting that due to the flexible array transformation,
> > the size of struct wmi_connect_event changed (now the size is 1 byte
> > smaller), and in order to preserve the logic of before the transformation,
> > the following change is needed:
> > 
> > 	-       if (len < sizeof(struct wmi_connect_event))
> > 	+       if (len <= sizeof(struct wmi_connect_event))
> > 
> > This issue was found with the help of Coccinelle and audited and fixed,
> > manually.
> > 
> > Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> > Link: https://github.com/KSPP/linux/issues/79
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> > Hi!
> > 
> > It'd be great if someone can confirm or comment on the following
> > changes described in the changelog text:
> > 
> >          -       if (len < sizeof(struct wmi_connect_event))
> >          +       if (len <= sizeof(struct wmi_connect_event))
> > 
> > Thanks
> > 
> >   drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
> >   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> > index 049d75f31f3c..ccdccead688e 100644
> > --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> > +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> > @@ -857,7 +857,7 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
> >   	struct wmi_connect_event *ev;
> >   	u8 *pie, *peie;
> > -	if (len < sizeof(struct wmi_connect_event))
> > +	if (len <= sizeof(struct wmi_connect_event))
> 
> this is another case where IMO the original code can remain since all it is
> really checking is to see if the entire "fixed" portion is present. in
> reality if there was just one byte of assoc_info the response would actually
> be invalid.

I see; that's actually what I needed to be clarified. I wasn't sure if
a channel list with no channels was valid and expected. Now I see it is. :)

> what is missing is logic that verifies len is large enough to hold the
> payload that is advertised via the beacon_ie_len, assoc_req_len, &
> assoc_resp_len members. without this even if you change the initial len
> check you can have a condition where len says there is one u8 in assoc_info
> (and pass the initial test) but the other three members indicate that much
> more data is present.
> 
> but that is a pre-existing shortcoming that should be handled with a
> separate patch.

Yeah; I'll consider extending this series to include a patch for that.

> >   		return -EINVAL;
> >   	ev = (struct wmi_connect_event *) datap;
> > diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> > index 432e4f428a4a..6b064e669d87 100644
> > --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> > +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> > @@ -1545,7 +1545,7 @@ struct wmi_connect_event {
> >   	u8 beacon_ie_len;
> >   	u8 assoc_req_len;
> >   	u8 assoc_resp_len;
> > -	u8 assoc_info[1];
> > +	u8 assoc_info[];
> >   } __packed;
> >   /* Disconnect Event */
> 
> whether or not you modify the length check consider this:
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Great. :)

Thanks a lot for the feedback!
--
Gustavo

