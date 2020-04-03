Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3DA19D095
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 08:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbgDCG4E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Apr 2020 02:56:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37584 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbgDCG4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 02:56:04 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7F820CECF9;
        Fri,  3 Apr 2020 09:05:35 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v3 1/1] Bluetooth: Prioritize SCO traffic
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
Date:   Fri, 3 Apr 2020 08:56:01 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7FD50BDC-A4B5-4ED9-8DAB-887039735800@holtmann.org>
References: <20200323194507.90944-1-abhishekpandit@chromium.org>
 <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> When scheduling TX packets, send all SCO/eSCO packets first, check for
> pending SCO/eSCO packets after every ACL/LE packet and send them if any
> are pending.  This is done to make sure that we can meet SCO deadlines
> on slow interfaces like UART.
> 
> If we were to queue up multiple ACL packets without checking for a SCO
> packet, we might miss the SCO timing. For example:
> 
> The time it takes to send a maximum size ACL packet (1024 bytes):
> t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
>        where 10/8 is uart overhead due to start/stop bits per byte
> 
> Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.
> 
> At a baudrate of 3000000, if we didn't check for SCO packets within 1024
> bytes, we would miss the 3.75ms timing window.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v3:
> * Removed hci_sched_sync
> 
> Changes in v2:
> * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> * Enabled SCO priority all the time and removed the sched_limit variable
> 
> net/bluetooth/hci_core.c | 106 +++++++++++++++++++++------------------
> 1 file changed, 57 insertions(+), 49 deletions(-)

patch has been applied to bluetooth-next tree.

However I have been a bit reluctant to apply this right away. I think when this code was originally written, we only had ACL and SCO packets. The world was pretty simple. And right now we also only have two packets types (ignoring ISO packets for now), but we added LE and eSCO as separate scheduling and thus “fake” packet types.

I have the feeling that this serialized packet processing will get us into trouble since we prioritize BR/EDR packets over LE packets and SCO over eSCO. I think we should have looked at all packets based on SO_PRIORITY and with ISO packets we have to most likely re-design this. Anyway, just something to think about.

Regards

Marcel

