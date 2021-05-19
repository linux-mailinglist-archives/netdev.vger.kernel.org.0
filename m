Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2FD389838
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhESUso convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 16:48:44 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52579 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhESUsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 16:48:43 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3791CCECD4;
        Wed, 19 May 2021 22:55:15 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v1] Bluetooth: disable filter dup when scan for adv
 monitor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210519102745.v1.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
Date:   Wed, 19 May 2021 22:47:20 +0200
Cc:     "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Yun-Hao Chung <howardchung@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <73ED48AE-974A-476C-83AD-E6D09CDCBFC9@holtmann.org>
References: <20210519102745.v1.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Disable duplicates filter when scanning for advertisement monitor for
> the following reasons. The scanning includes active scan and passive
> scan.
> 
> For HW pattern filtering (ex. MSFT), some controllers ignore
> RSSI_Sampling_Period when the duplicates filter is enabled.
> 
> For SW pattern filtering, when we're not doing interleaved scanning, it
> is necessary to disable duplicates filter, otherwise hosts can only
> receive one advertisement and it's impossible to know if a peer is still
> in range.

can we be a bit more specific on which controller does what. I am not inclined to always disable duplicate filtering unless your controller doesn’t do what you want it to do.

I also disagree with the last statement. If the device moved out of range (or comes back for that matter) you should get a HCI_VS_MSFT_LE_Monitor_Device_Event event that tells you if a device is in range or not.

Device leaving:

> HCI Event: LE Meta Event (0x3e) plen 43
      LE Advertising Report (0x02)
        Num reports: 1
        Event type: Non connectable undirected - ADV_NONCONN_IND (0x03)
        Address type: Random (0x01)
        Address: 01:9A:1F:C0:30:15 (Non-Resolvable)
        Data length: 31
        Flags: 0x1a
          LE General Discoverable Mode
          Simultaneous LE and BR/EDR (Controller)
          Simultaneous LE and BR/EDR (Host)
        16-bit Service UUIDs (complete): 1 entry
          Apple, Inc. (0xfd6f)
        Service Data (UUID 0xfd6f): f47698ff9243617d917ac521b5fcfd436afdb285
        RSSI: -86 dBm (0xaa)
> HCI Event: Vendor (0xff) plen 18
        23 79 54 33 77 88 97 68 02 01 15 30 c0 1f 9a 01  #yT3w..h...0....
        00 00                                            ..              

Device coming back:

> HCI Event: Vendor (0xff) plen 18
        23 79 54 33 77 88 97 68 02 01 95 b9 0b 32 22 2a  #yT3w..h.....2"*
        00 01                                            ..              
> HCI Event: LE Meta Event (0x3e) plen 43
      LE Advertising Report (0x02)
        Num reports: 1
        Event type: Non connectable undirected - ADV_NONCONN_IND (0x03)
        Address type: Random (0x01)
        Address: 2A:22:32:0B:B9:95 (Non-Resolvable)
        Data length: 31
        Flags: 0x1a
          LE General Discoverable Mode
          Simultaneous LE and BR/EDR (Controller)
          Simultaneous LE and BR/EDR (Host)
        16-bit Service UUIDs (complete): 1 entry
          Apple, Inc. (0xfd6f)
        Service Data (UUID 0xfd6f): 0b861791a0fb7adcf8b45f951f7d4b7c7fc8e3fd
        RSSI: -27 dBm (0xe5)

Regards

Marcel

