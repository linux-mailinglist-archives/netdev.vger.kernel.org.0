Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831894FBF7C
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbiDKOtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiDKOtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:49:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A770613CCD;
        Mon, 11 Apr 2022 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=0PQqok4VtRI+EwdhTAimsSjz59ctIfWRywOAu+VFE1Y=;
        t=1649688425; x=1650898025; b=p2I19GvzgotvmG6EWeIK5/pglK/kmHE0QvxQZBDPA6voskx
        nYmiFgGav/m/ERvIE2oMboDlzjFWzyjLPuTYqSL9vObAsb9xB8hK2am8b8+ZFh/iDxT49h8ZohLdH
        oJwy+AJchpci6CwEVS8F8qWC8Nvo2JcI1qocKhUWX3S6PzHqbKetdaFCdwXFRD3eCF3A9fHkthT46
        zOyCc48EQbaT+s1lSZGs84Xiyn9uJ3QfB3MFw3xdqYb9GobKdCFdP2aQyh5VHqSGFmZQ+Rht6CBdr
        2YgCZo6vKZ7MEMhHfgh8UNIFDOWxbbcsEDPM386Ksi+Musm2tEGJUCP/5HaDil7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ndvJY-008KQx-UY;
        Mon, 11 Apr 2022 16:46:49 +0200
Message-ID: <446ea9872d46fe0ad594cfa6d3df224cfcb5223f.camel@sipsolutions.net>
Subject: Re: [Linux 5.18-rc1] WARNING: possible circular locking dependency
 detected at (rtw_ops_config, ieee80211_mgd_probe_ap)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>
Date:   Mon, 11 Apr 2022 16:46:47 +0200
In-Reply-To: <875af62c-363e-3fc3-9c38-dcf8b3071c99@gnuweeb.org>
References: <2565e500-0e2f-c688-19e0-d241e4e7e031@gnuweeb.org>
         <875af62c-363e-3fc3-9c38-dcf8b3071c99@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-07 at 08:26 +0700, Ammar Faizi wrote:
> 
> [21860.955836]  Possible unsafe locking scenario:
> 
> [21860.955837]        CPU0                    CPU1
> [21860.955837]        ----                    ----
> [21860.955838]   lock(&local->iflist_mtx);
> [21860.955839]                                lock(&rtwdev->mutex);
> [21860.955840]                                lock(&local->iflist_mtx);
> [21860.955841]   lock(&rtwdev->mutex);
> [21860.955842]
>                   *** DEADLOCK ***
> 

The driver needs to fix this, cannot call ieee80211_iterate_interfaces()
inside a section locked this way. I _think_ this deadlock used to be
documented by it looks like that documentation got moved around or
something.

johannes
