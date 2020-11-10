Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4172ADCFD
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgKJRfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgKJRfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:35:36 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759C7C0613CF;
        Tue, 10 Nov 2020 09:35:36 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kcXYC-0053JM-1H; Tue, 10 Nov 2020 18:35:24 +0100
Message-ID: <3b851462d9bfd914aeb9f5b432e4c076f6c330f3.camel@sipsolutions.net>
Subject: Re: [PATCH] rfkill: Fix use-after-free in rfkill_resume()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Claire Chang <tientzu@chromium.org>, davem@davemloft.net,
        kuba@kernel.org, hdegoede@redhat.com, marcel@holtmann.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Nov 2020 18:35:07 +0100
In-Reply-To: <20201110084908.219088-1-tientzu@chromium.org> (sfid-20201110_094924_445207_CC99576F)
References: <20201110084908.219088-1-tientzu@chromium.org>
         (sfid-20201110_094924_445207_CC99576F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-10 at 16:49 +0800, Claire Chang wrote:
> If a device is getting removed or reprobed during resume, use-after-free
> might happen. For example, h5_btrtl_resume()[drivers/bluetooth/hci_h5.c]
> schedules a work queue for device reprobing. During the reprobing, if
> rfkill_set_block() in rfkill_resume() is called after the corresponding
> *_unregister() and kfree() are called, there will be an use-after-free
> in hci_rfkill_set_block()[net/bluetooth/hci_core.c].


Not sure I understand. So you're saying

 * something (h5_btrtl_resume) schedules a worker
 * said worker run, when it runs, calls rfkill_unregister()
 * somehow rfkill_resume() still gets called after this

But that can't really be right, device_del() removes it from the PM
lists?

johannes


