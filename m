Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA667D9962
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394334AbfJPSmv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 14:42:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52361 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfJPSmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:42:50 -0400
Received: from surfer-172-29-2-69-hotspot.internet-for-guests.com (p2E5701B0.dip0.t-ipconnect.de [46.87.1.176])
        by mail.holtmann.org (Postfix) with ESMTPSA id 59577CECDF;
        Wed, 16 Oct 2019 20:51:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] RFC: Bluetooth: missed cpu_to_le16 conversion in
 hci_init4_req
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191016122022.kz4xzx4hzmtuoh5l@netronome.com>
Date:   Wed, 16 Oct 2019 20:42:48 +0200
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        linux-kernel@lists.codethink.co.uk,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BFA3CB11-5FD8-4BD8-9DDA-62707AB84626@holtmann.org>
References: <20191016113943.19256-1-ben.dooks@codethink.co.uk>
 <20191016122022.kz4xzx4hzmtuoh5l@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

>> It looks like in hci_init4_req() the request is being
>> initialised from cpu-endian data but the packet is specified
>> to be little-endian. This causes an warning from sparse due
>> to __le16 to u16 conversion.
>> 
>> Fix this by using cpu_to_le16() on the two fields in the packet.
>> 
>> net/bluetooth/hci_core.c:845:27: warning: incorrect type in assignment (different base types)
>> net/bluetooth/hci_core.c:845:27:    expected restricted __le16 [usertype] tx_len
>> net/bluetooth/hci_core.c:845:27:    got unsigned short [usertype] le_max_tx_len
>> net/bluetooth/hci_core.c:846:28: warning: incorrect type in assignment (different base types)
>> net/bluetooth/hci_core.c:846:28:    expected restricted __le16 [usertype] tx_time
>> net/bluetooth/hci_core.c:846:28:    got unsigned short [usertype] le_max_tx_time
>> 
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Cc: Johan Hedberg <johan.hedberg@gmail.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: linux-bluetooth@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> net/bluetooth/hci_core.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> index 04bc79359a17..b2559d4bed81 100644
>> --- a/net/bluetooth/hci_core.c
>> +++ b/net/bluetooth/hci_core.c
>> @@ -842,8 +842,8 @@ static int hci_init4_req(struct hci_request *req, unsigned long opt)
>> 	if (hdev->le_features[0] & HCI_LE_DATA_LEN_EXT) {
>> 		struct hci_cp_le_write_def_data_len cp;
>> 
>> -		cp.tx_len = hdev->le_max_tx_len;
>> -		cp.tx_time = hdev->le_max_tx_time;
>> +		cp.tx_len = cpu_to_le16(hdev->le_max_tx_len);
>> +		cp.tx_time = cpu_to_le16(hdev->le_max_tx_time);
> 
> I would suggest that the naming of the le_ fields of struct hci_dev
> implies that the values stored in those fields should be little endian
> (but those that are more than bone byte wide are not).

the le_ stands for Low Energy and not for Little Endian.

Regards

Marcel

