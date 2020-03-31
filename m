Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270CC198C10
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 08:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgCaGG7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 02:06:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45331 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgCaGG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 02:06:59 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5DDE2CECC4;
        Tue, 31 Mar 2020 08:16:30 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v4 2/2] Bluetooth: btusb: Read the supported features of
 Microsoft vendor extension
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABmPvSF2SMWUs_62jeAse3DbgRgQBiOinKZQuPN7k+MKYL6eDw@mail.gmail.com>
Date:   Tue, 31 Mar 2020 08:06:57 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E1FC614F-47DD-4455-8D73-A0D95D7E0F26@holtmann.org>
References: <20200328074632.21907-1-mcchou@chromium.org>
 <20200328004507.v4.2.Ic59b637deef8e646f6599a80c9a2aa554f919e55@changeid>
 <1FA9284F-C8DD-40A3-81A7-65AC6DE1E3C5@holtmann.org>
 <CABmPvSF2SMWUs_62jeAse3DbgRgQBiOinKZQuPN7k+MKYL6eDw@mail.gmail.com>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

>>> This defines opcode and packet structures of Microsoft vendor extension.
>>> For now, we add only the HCI_VS_MSFT_Read_Supported_Features command. See
>>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
>>> microsoft-defined-bluetooth-hci-commands-and-events#microsoft-defined-
>>> bluetooth-hci-events for more details.
>>> Upon initialization of a hci_dev, we issue a
>>> HCI_VS_MSFT_Read_Supported_Features command to read the supported features
>>> of Microsoft vendor extension if the opcode of Microsoft vendor extension
>>> is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
>>> bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
>>> hci_vs_msft_read_supported_features for more details.
>>> This was verified on a device with Intel ThunderPeak BT controller where
>>> the Microsoft vendor extension features are 0x000000000000003f.
>>> 
>>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>>> 
>>> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
>>> ---
>>> 
>>> Changes in v4:
>>> - Move MSFT's do_open() and do_close() from net/bluetooth/hci_core.c to
>>> net/bluetooth/msft.c.
>>> - Other than msft opcode, define struct msft_data to host the rest of
>>> information of Microsoft extension and leave a void* pointing to a
>>> msft_data in struct hci_dev.
>>> 
>>> Changes in v3:
>>> - Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().
>>> 
>>> Changes in v2:
>>> - Issue a HCI_VS_MSFT_Read_Supported_Features command with
>>> __hci_cmd_sync() instead of constructing a request.
>>> 
>>> include/net/bluetooth/hci_core.h |   1 +
>>> net/bluetooth/hci_core.c         |   5 ++
>>> net/bluetooth/hci_event.c        |   5 ++
>>> net/bluetooth/msft.c             | 126 +++++++++++++++++++++++++++++++
>>> net/bluetooth/msft.h             |  10 +++
>>> 5 files changed, 147 insertions(+)
>>> 
>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>>> index 239cae2d9998..59ddcd3a52cc 100644
>>> --- a/include/net/bluetooth/hci_core.h
>>> +++ b/include/net/bluetooth/hci_core.h
>>> @@ -486,6 +486,7 @@ struct hci_dev {
>>> 
>>> #if IS_ENABLED(CONFIG_BT_MSFTEXT)
>>>      __u16                   msft_opcode;
>>> +     void                    *msft_data;
>>> #endif
>>> 
>>>      int (*open)(struct hci_dev *hdev);
>>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>>> index dbd2ad3a26ed..c38707de767a 100644
>>> --- a/net/bluetooth/hci_core.c
>>> +++ b/net/bluetooth/hci_core.c
>>> @@ -44,6 +44,7 @@
>>> #include "hci_debugfs.h"
>>> #include "smp.h"
>>> #include "leds.h"
>>> +#include "msft.h"
>>> 
>>> static void hci_rx_work(struct work_struct *work);
>>> static void hci_cmd_work(struct work_struct *work);
>>> @@ -1563,6 +1564,8 @@ static int hci_dev_do_open(struct hci_dev *hdev)
>>>          hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
>>>              ret = hdev->set_diag(hdev, true);
>>> 
>>> +     msft_do_open(hdev);
>>> +
>>>      clear_bit(HCI_INIT, &hdev->flags);
>>> 
>>>      if (!ret) {
>>> @@ -1758,6 +1761,8 @@ int hci_dev_do_close(struct hci_dev *hdev)
>>> 
>>>      hci_sock_dev_event(hdev, HCI_DEV_DOWN);
>>> 
>>> +     msft_do_close(hdev);
>>> +
>>>      if (hdev->flush)
>>>              hdev->flush(hdev);
>>> 
>>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>>> index 20408d386268..42b5871151a6 100644
>>> --- a/net/bluetooth/hci_event.c
>>> +++ b/net/bluetooth/hci_event.c
>>> @@ -35,6 +35,7 @@
>>> #include "a2mp.h"
>>> #include "amp.h"
>>> #include "smp.h"
>>> +#include "msft.h"
>>> 
>>> #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
>>>               "\x00\x00\x00\x00\x00\x00\x00\x00"
>>> @@ -6144,6 +6145,10 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
>>>              hci_num_comp_blocks_evt(hdev, skb);
>>>              break;
>>> 
>>> +     case HCI_EV_VENDOR:
>>> +             msft_vendor_evt(hdev, skb);
>>> +             break;
>>> +
>>>      default:
>>>              BT_DBG("%s event 0x%2.2x", hdev->name, event);
>>>              break;
>>> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>>> index 7609932c48ca..f76e4c79556e 100644
>>> --- a/net/bluetooth/msft.c
>>> +++ b/net/bluetooth/msft.c
>>> @@ -6,6 +6,24 @@
>>> 
>>> #include "msft.h"
>>> 
>>> +#define MSFT_OP_READ_SUPPORTED_FEATURES              0x00
>>> +struct msft_cp_read_supported_features {
>>> +     __u8   sub_opcode;
>>> +} __packed;
>>> +struct msft_rp_read_supported_features {
>>> +     __u8   status;
>>> +     __u8   sub_opcode;
>>> +     __le64 features;
>>> +     __u8   evt_prefix_len;
>>> +     __u8   evt_prefix[0];
>>> +} __packed;
>>> +
>>> +struct msft_data {
>>> +     __u64 features;
>>> +     __u8  evt_prefix_len;
>>> +     __u8  *evt_prefix;
>>> +};
>>> +
>>> void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
>>> {
>>>      hdev->msft_opcode = opcode;
>>> @@ -14,3 +32,111 @@ void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
>>>                  hdev->msft_opcode);
>>> }
>>> EXPORT_SYMBOL(msft_set_opcode);
>>> +
>>> +static struct msft_data *read_supported_features(struct hci_dev *hdev)
>>> +{
>>> +     struct msft_data *msft;
>> 
>> I used a second parameter, but yes, my initial code was totally flawed with the msft_data access.
> Ack.
>> 
>>> +     struct msft_cp_read_supported_features cp;
>>> +     struct msft_rp_read_supported_features *rp;
>>> +     struct sk_buff *skb;
>>> +
>>> +     cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
>>> +
>>> +     skb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
>>> +                          HCI_CMD_TIMEOUT);
>>> +     if (IS_ERR(skb)) {
>>> +             bt_dev_err(hdev, "Failed to read MSFT supported features (%ld)",
>>> +                        PTR_ERR(skb));
>>> +             return NULL;
>>> +     }
>>> +
>>> +     if (skb->len < sizeof(*rp)) {
>>> +             bt_dev_err(hdev, "MSFT supported features length mismatch");
>>> +             goto failed;
>>> +     }
>>> +
>>> +     rp = (struct msft_rp_read_supported_features *)skb->data;
>>> +
>>> +     if (rp->sub_opcode != MSFT_OP_READ_SUPPORTED_FEATURES)
>>> +             goto failed;
>>> +
>>> +     msft = kzalloc(sizeof(*msft), GFP_KERNEL);
>>> +     if (!msft)
>>> +             goto failed;
>>> +
>>> +     if (rp->evt_prefix_len > 0) {
>>> +             msft->evt_prefix = kmemdup(rp->evt_prefix, rp->evt_prefix_len,
>>> +                                        GFP_KERNEL);
>>> +             if (!msft->evt_prefix)
>>> +                     goto failed;
>>> +     }
>>> +
>>> +     msft->evt_prefix_len = rp->evt_prefix_len;
>>> +     msft->features = __le64_to_cpu(rp->features);
>>> +     kfree_skb(skb);
>>> +
>>> +     bt_dev_info(hdev, "MSFT supported features %llx", msft->features);
>>> +     return msft;
>>> +
>>> +failed:
>>> +     kfree_skb(skb);
>>> +     return NULL;
>>> +}
>>> +
>>> +void msft_do_open(struct hci_dev *hdev)
>>> +{
>>> +     if (hdev->msft_opcode == HCI_OP_NOP)
>>> +             return;
>>> +
>>> +     bt_dev_dbg(hdev, "Initialize MSFT extension");
>>> +     hdev->msft_data = read_supported_features(hdev);
>>> +}
>>> +
>>> +void msft_do_close(struct hci_dev *hdev)
>>> +{
>>> +     struct msft_data *msft = hdev->msft_data;
>>> +
>>> +     if (!msft)
>>> +             return;
>>> +
>>> +     bt_dev_dbg(hdev, "Cleanup of MSFT extension");
>>> +
>>> +     hdev->msft_data = NULL;
>>> +
>>> +     kfree(msft->evt_prefix);
>>> +     kfree(msft);
>>> +}
>>> +
>>> +int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
>>> +{
>> 
>> So this was on purpose void. There is no point in returning any feedback from this function. It either handles the event or it doesn’t. The caller function doesn’t care.
> I was thinking that if there are two extensions, the vendor events
> should be processed either msft or the other function. Therefore,
> should we use the return value to determine whether to hand skb to the
> other function?

my thinking was that we just hand the vendor events to all functions. Let them deal with the details. I would not over-design this right now. Keep it simple. As long as it is not userspace facing API, we can easily change that when we need it.

Regards

Marcel

