Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8FA19F87B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgDFPGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:06:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60306 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgDFPGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:06:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jLTKO-00A6Sm-OD; Mon, 06 Apr 2020 17:06:20 +0200
Message-ID: <5575dfe84aa745a3c2a61e240c3d150dc8d9446f.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthias-Peter =?ISO-8859-1?Q?Sch=F6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Date:   Mon, 06 Apr 2020 17:06:19 +0200
In-Reply-To: <CABPxzY++YMBPTV4quAkYvEAMfULjMXLkVfNzwocwubno5HO2Bw@mail.gmail.com> (sfid-20200406_162554_186372_29D110B6)
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
         <87ftdgokao.fsf@tynnyri.adurom.net>
         <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
         <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com>
         <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
         <87imiczrwm.fsf@kamboji.qca.qualcomm.com>
         <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
         <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
         <87v9mcycbf.fsf@kamboji.qca.qualcomm.com>
         <CABPxzYKs3nj0AUX4L-j87Db8v3WnM4uGif9nRTGgx1m2HNN8Rg@mail.gmail.com>
         <35cadbaff1239378c955014f9ad491bc68dda028.camel@sipsolutions.net>
         <CABPxzY++YMBPTV4quAkYvEAMfULjMXLkVfNzwocwubno5HO2Bw@mail.gmail.com>
         (sfid-20200406_162554_186372_29D110B6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-06 at 19:55 +0530, Krishna Chaitanya wrote:

> > iw phy0 interface add wlan0 type station
> > ip link set wlan0 up
> Ah okay, got it, thanks. Very narrow window though :-) as the
> alloc_ordered_workqueue
> doesn't need RTNL and there is a long way to go to do if_add() from
> user and setup
> the driver for interrupts. 

True, I do wonder how this is hit. Maybe something with no preempt and a
uevent triggering things?

> Again depends on the driver though, it
> should properly handle
> pending ieee80211_register_hw() with start().

It could, but it'd be really tricky. Much better to fix mac80211.

johannes

