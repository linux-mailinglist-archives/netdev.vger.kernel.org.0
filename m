Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D49D41AD8A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbhI1LHB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Sep 2021 07:07:01 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:48518 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbhI1LHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:07:00 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1865ACECD9;
        Tue, 28 Sep 2021 13:05:20 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [RFC] bt control interface out from debugfs
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAD8XO3Z3FDFdaJOgoXgjn=_Ly6AQp+wugKNDN01098EVJB4qEw@mail.gmail.com>
Date:   Tue, 28 Sep 2021 13:05:19 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?Q?Fran=C3=A7ois_Ozog?= <francois.ozog@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <98214D73-18D8-4A7E-BB66-6E69E8A608DB@holtmann.org>
References: <CAD8XO3Z3FDFdaJOgoXgjn=_Ly6AQp+wugKNDN01098EVJB4qEw@mail.gmail.com>
To:     Maxim Uvarov <maxim.uvarov@linaro.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

> I think we need to move control for BT 6lowpan connection out of
> kernel debugfs to user space tools. I.e. use hcitool or iproute2 and
> add proper non debug kernel interface for the tools.
> I would like to hear about some suggestions on what is the best interface here.
> 
> Currently commands to setup connection are:
> echo 1 > /sys/kernel/debug/bluetooth/6lowpan_enable
> echo "connect 80:E1:26:1B:95:81 1" > /sys/kernel/debug/bluetooth/6lowpan_control
> 
> It looks logical to enable 6lowpan inside hcitool. I.e. extend current
> AF_BLUETOOTH socket protocol:
> dd = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, BTPROTO_HCI)
> getsockopt(dd, SOL_HCI, HCI_FILTER, ..
> add some HCI_6LOWPAN_ENABLE call.
> What are your thoughts on that?

NAK.

> 
> Then we have an IP stack on top of the BT layer, and hcitool does not
> intend to setup ip connection. iproute2 might be more suitable for
> this case. Something like:
> ip link connect dev bt0 type bt 80:E1:26:1B:95:81 type local
> (type 1- local, 2- public) .
> 
> But here is the problem that "ip link connect" is missing in current
> tools. And usually we just set up a local connection and connect from
> the app using a socket.  With IP over BT connection is different  -
> we should be connected before.
> 
> If we implement "ip link connect" then it will be possible to reuse it
> for all other pear to pear connections like vpn wireguard.
> 
> Any thoughts on an interface here?

Sure, give that a spin.

Regards

Marcel

