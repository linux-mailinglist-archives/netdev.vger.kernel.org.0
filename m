Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CB581257
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbiGZLvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGZLvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:51:07 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE932ED1;
        Tue, 26 Jul 2022 04:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1658836225; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=WSpg8KPJETneI5AZXqZG2Xo+QF9K6OWYXEGoNLBhcVRq1DV+/Y1sqc9n+DAX3SaiTADgCejJ/zcn3V8f/35O40cJZVpczIlv8V08xFBsuuGA7SKIFRLu/MYvy3X2hUTOeapUr9s5qEkAXYDI9PTu9F8nSNuLXWfGF1qB4fdI56U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1658836225; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=l0zptIRyEcZyy0C3kf9GDQRw2Zi+JN1Q7S6n+N0vGIM=; 
        b=fXYBHscjQeqXdzbflmTvcDxoHxEMvkX5RSrwbNEMkKBioDpJg8b1AHK0Q1eDxIldwZ4eRbwRN6TFcIxePTYWB1Hoquev0qAPkodcDHotHR9uKazGZhbTsfH+JxZmhiwrYIbp0nIPVAWvuRKFY7GKSj6yRXrJCk29d8Z73XXT2DE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1658836225;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=l0zptIRyEcZyy0C3kf9GDQRw2Zi+JN1Q7S6n+N0vGIM=;
        b=GXuIDkiSSLbukku99oGbHP0rFZ8U+DpqqvJ2y8bEtutG8U5Ofv1bXLmS6Wda5ScD
        98NAMUYRoOyJjULA6Liu5rl6D6KWFYpVNggaaOmJhxRqEsV2I/u3xoHttg/aKFp0NmI
        mUifysZ3Bibdl41v6CpRnIQiDkYjWFtCfGNVHDOI=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1658836214239674.8528097307659; Tue, 26 Jul 2022 17:20:14 +0530 (IST)
Date:   Tue, 26 Jul 2022 17:20:14 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <1823a57e1cc.284bcb72769210.9086833687126088621@siddh.me>
In-Reply-To: <8735eomc5h.fsf@kernel.org>
References: <20220701145423.53208-1-code@siddh.me> <8735eomc5h.fsf@kernel.org>
Subject: Re: [PATCH] net: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 15:25:06 +0530  Kalle Valo <kvalo@kernel.org> wrote --- 
> The title should be:
> 
> wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 

Noted. Will fix.

Thanks,
Siddh
