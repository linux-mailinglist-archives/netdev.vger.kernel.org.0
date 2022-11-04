Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C107619D23
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiKDQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKDQZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:25:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E844F10;
        Fri,  4 Nov 2022 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=mueebaL38FcUSyeQjIobsTZF1EWJPQVH0pYABKEMbSQ=;
        t=1667579123; x=1668788723; b=ULmpVSbtjPRgyR1XU6rdZFqUGovGHTjTIIopU0I4qrXHe7X
        WaAJEnOzPNvw8W4wQ7D2hgN4L0E+pDlaSd32FuHmV/FOeMsdlrIKW3BpoXFtl86y2B3aRs2HZeeJq
        QsBisjVVpVx3N/WErDbyrNNkYrZDoyVx4M49wKXN8l63wN1vqyP5pFyNp/Im61515BTwJgahiytPO
        TImgySX6hY43mCsbdsnN0I2oTdC6FMb/4ROXSrVuI9RSceyAvMAA4X7mQtJ7pzemxhGAvGQJJK7Kl
        JaFAaFRVSMny9xtoP1n1RbYY4eviO4promqjDWMsxUEnS0islwXBgE8bk5Y2/xQg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oqzVG-008utM-2M;
        Fri, 04 Nov 2022 17:25:10 +0100
Message-ID: <f3b0adccfff86b687bf2e9fd3e3f9657444bfdf0.camel@sipsolutions.net>
Subject: Re: [PATCH v3] wifi: rsi: Fix handling of 802.3 EAPOL frames sent
 via control port
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     Angus Ainslie <angus@akkea.ca>, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 04 Nov 2022 17:25:09 +0100
In-Reply-To: <d6c8594159368034d47a169ccdd50bc65a1ad894.camel@sipsolutions.net>
References: <20221104155841.213387-1-marex@denx.de>
         <cf7da8e9a135fee1a9ac0e8f768a2a13bbba058d.camel@sipsolutions.net>
         <a3ef782d-9c85-d752-52b5-589d5e1f1bd5@denx.de>
         <d6c8594159368034d47a169ccdd50bc65a1ad894.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(removing Amitkumar Karwar <amit.karwar@redpinesignals.com> as that
keeps bouncing)

On Fri, 2022-11-04 at 17:23 +0100, Johannes Berg wrote:
> On Fri, 2022-11-04 at 17:09 +0100, Marek Vasut wrote:
> >=20
> > In V2 it was suggested I deduplicate this into a separate function,=20
> > since the test is done in multiple places. I would like to keep it=20
> > deduplicated.
>=20
> Well, it's now a lot simpler, so one might argue that it's not needed.
>=20
> But anyway you're touching the hot-path of this driver, and making it an
> inline still keeps it de-duplicated, so not sure why you wouldn't just
> move the rsi_is_tx_eapol into the header file as static inline?
>=20

Though honestly, if we thought it was worth deduplicating a simple bit
check like that, we could define an inline helper in mac80211.h. I'm not
really convinced it is :)

But hey, that's not my driver, so ultimately I don't _really_ care so
much.

johannes
