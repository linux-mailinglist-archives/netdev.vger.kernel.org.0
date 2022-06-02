Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE61553BC05
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiFBP7a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jun 2022 11:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiFBP73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:59:29 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47C17D02BB;
        Thu,  2 Jun 2022 08:59:25 -0700 (PDT)
Received: from smtpclient.apple (p4ff9fc30.dip0.t-ipconnect.de [79.249.252.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2E1E8CED19;
        Thu,  2 Jun 2022 17:59:24 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v6 5/5] Bluetooth: let HCI_QUALITY_REPORT persist over
 adapter power cycle
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220526112135.2486883-3-josephsih@chromium.org>
Date:   Thu, 2 Jun 2022 17:59:23 +0200
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@google.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0DB8D064-222A-4420-8F9F-2BEEA63DF76A@holtmann.org>
References: <20220526112135.2486883-1-josephsih@chromium.org>
 <20220526112135.2486883-3-josephsih@chromium.org>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> The quality report specifications, including AOSP Bluetooth Quality
> Report and Intel Telemetry Event, do not define what happen when
> the adapter is turned off and then on. To be consistent among
> different specifications and vendors, the quality report feature is
> turned off when the adapter is powered off and is turned on when
> the adapter is powered on if the feature has been on before power
> cycle.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> (no changes since v5)
> 
> Changes in v5:
> - This is a new patch in this series changes version.
> 
> include/net/bluetooth/hci_core.h |  1 -
> net/bluetooth/hci_sync.c         | 35 +++++++++++++++++++++++++++++++-
> 2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 9e48d606591e..5788350efa68 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -807,7 +807,6 @@ extern struct mutex hci_cb_list_lock;
> 		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
> 		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
> 		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
> -		hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);	\
> 	} while (0)

this really need to go into your 1/5 patch.

> 
> #define hci_dev_le_state_simultaneous(hdev) \
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index a6ada9dcede5..12a18d046bb6 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -3849,6 +3849,31 @@ static const struct {
> 			 "advertised, but not supported.")
> };
> 
> +static void suspend_resume_quality_report(struct hci_dev *hdev, bool enable)
> +{
> +	int err;
> +
> +	/* Suspend and resume quality report only when the feature has
> +	 * already been enabled. The HCI_QUALITY_REPORT flag, as an indicator
> +	 * whether to re-enable the feature after resume, is not changed by
> +	 * suspend/resume.
> +	 */
> +	if (!hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
> +		return;
> +
> +	if (hdev->set_quality_report)
> +		err = hdev->set_quality_report(hdev, enable);
> +	else
> +		err = aosp_set_quality_report(hdev, enable);
> +
> +	if (err)
> +		bt_dev_err(hdev, "%s quality report error %d",
> +			   enable ? "resume" : "suspend", err);
> +	else
> +		bt_dev_info(hdev, "%s quality report",
> +			    enable ? "resume" : "suspend");

Do you really need this “debug” output?

> +}
> +
> int hci_dev_open_sync(struct hci_dev *hdev)
> {
> 	int ret = 0;
> @@ -4013,6 +4038,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
> 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> 		msft_do_open(hdev);
> 		aosp_do_open(hdev);
> +		suspend_resume_quality_report(hdev, true);
> 	}
> 
> 	clear_bit(HCI_INIT, &hdev->flags);
> @@ -4095,6 +4121,14 @@ int hci_dev_close_sync(struct hci_dev *hdev)
> 
> 	hci_request_cancel_all(hdev);
> 
> +	/* Disable quality report and close aosp before shutdown()
> +	 * is called. Otherwise, some chips may panic.
> +	 */
> +	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> +		suspend_resume_quality_report(hdev, false);
> +		aosp_do_close(hdev);
> +	}
> +

Why move aosp_do_close here. I prefer to keep it where it was.

> 	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> 	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> 	    test_bit(HCI_UP, &hdev->flags)) {
> @@ -4158,7 +4192,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
> 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
> 
> 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> -		aosp_do_close(hdev);
> 		msft_do_close(hdev);
> 	}

Regards

Marcel

