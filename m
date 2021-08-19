Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08A43F1C95
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhHSPYY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:24:24 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59363 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbhHSPYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:24:17 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 04B76CED17;
        Thu, 19 Aug 2021 17:23:37 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [RFC PATCH 00/15] create power sequencing subsystem
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
Date:   Thu, 19 Aug 2021 17:23:36 +0200
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        MSM <linux-arm-msm@vger.kernel.org>, linux-mmc@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1CA665D1-86F0-45A1-862D-17DAB3ABA974@holtmann.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

> This is an RFC of the proposed power sequencer subsystem. This is a
> generification of the MMC pwrseq code. The subsystem tries to abstract
> the idea of complex power-up/power-down/reset of the devices.
> 
> The primary set of devices that promted me to create this patchset is
> the Qualcomm BT+WiFi family of chips. They reside on serial+platform
> interfaces (older generations) or on serial+PCIe (newer generations).
> They require a set of external voltage regulators to be powered on and
> (some of them) have separate WiFi and Bluetooth enable GPIOs.
> 
> This patchset being an RFC tries to demonstrate the approach, design and
> usage of the pwrseq subsystem. Following issues are present in the RFC
> at this moment but will be fixed later if the overall approach would be
> viewed as acceptable:
> 
> - No documentation
>   While the code tries to be self-documenting proper documentation
>   would be required.
> 
> - Minimal device tree bindings changes
>   There are no proper updates for the DT bindings (thus neither Rob
>   Herring nor devicetree are included in the To/Cc lists). The dt
>   schema changes would be a part of v1.
> 
> - Lack of proper PCIe integration
>   At this moment support for PCIe is hacked up to be able to test the
>   PCIe part of qca6390. Proper PCIe support would require automatically
>   powering up the devices before the scan basing on the proper device
>   structure in the device tree.
> 
> ----------------------------------------------------------------
> Dmitry Baryshkov (15):
>      power: add power sequencer subsystem
>      pwrseq: port MMC's pwrseq drivers to new pwrseq subsystem
>      mmc: core: switch to new pwrseq subsystem
>      ath10k: add support for pwrseq sequencing
>      Bluetooth: hci_qca: merge qca_power into qca_serdev
>      Bluetooth: hci_qca: merge init paths
>      Bluetooth: hci_qca: merge qca_power_on with qca_regulators_init
>      Bluetooth: hci_qca: futher rework of power on/off handling
>      Bluetooth: hci_qca: add support for pwrseq

any chance you can try to abandon patching hci_qca. The serdev support in hci_uart is rather hacking into old line discipline code and it is not aging well. It is really becoming a mess.

I would say that the Qualcomm serial devices could use a separate standalone serdev driver. A while I send an RFC for a new serdev driver.

https://www.spinics.net/lists/linux-bluetooth/msg74918.html

There I had the idea that simple vendor specifics can be in that driver (like the Broadcom part I added there), but frankly the QCA specifics are a bit too specific and it should be a separate driver. However I think this would be a good starting point.

In general a H:4 based Bluetooth driver is dead simple with the help of h4_recv.h helper we have in the kernel. The complicated part is the power management pieces or any vendor specific low-power protocol they are running on that serial line. And since you are touching this anyway, doing a driver from scratch might be lot simpler and cleaner. It would surely help all the new QCA device showing up in the future.

Regards

Marcel

