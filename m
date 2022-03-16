Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445414DB385
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiCPOnW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Mar 2022 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiCPOnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:43:21 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D61D15F257;
        Wed, 16 Mar 2022 07:42:05 -0700 (PDT)
Received: from smtpclient.apple (p5b3d2183.dip0.t-ipconnect.de [91.61.33.131])
        by mail.holtmann.org (Postfix) with ESMTPSA id BDC18CECF7;
        Wed, 16 Mar 2022 15:42:04 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH 2/2] Bluetooth: Send AdvMonitor Dev Found for all matched
 devices
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220312020707.2.Ie20f132ad5cb6bcd435d6c6e0fca8a9d858e83d4@changeid>
Date:   Wed, 16 Mar 2022 15:42:04 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B4529896-AA8A-40F5-BC3D-A887E2C690E1@holtmann.org>
References: <20220312020707.1.I2b7f789329979102339d7e0717522ba417b63109@changeid>
 <20220312020707.2.Ie20f132ad5cb6bcd435d6c6e0fca8a9d858e83d4@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> When an Advertisement Monitor is configured with SamplingPeriod 0xFF,
> the controller reports only one adv report along with the MSFT Monitor
> Device event.
> 
> When an advertiser matches multiple monitors, some controllers send one
> adv report for each matched monitor; whereas, some controllers send just
> one adv report for all matched monitors.
> 
> In such a case, report Adv Monitor Device Found event for each matched
> monitor.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> net/bluetooth/mgmt.c | 70 +++++++++++++++++++++++---------------------
> 1 file changed, 37 insertions(+), 33 deletions(-)

patch has been applied to bluetooth-next tree.

> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index d59c70e9166f..e4da2318a2f6 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9628,17 +9628,44 @@ void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
> 		   NULL);
> }
> 
> +static void mgmt_send_adv_monitor_device_found(struct hci_dev *hdev,
> +					       struct sk_buff *skb,
> +					       struct sock *skip_sk,
> +					       u16 handle)
> +{
> +	struct sk_buff *advmon_skb;
> +	size_t advmon_skb_len;
> +	__le16 *monitor_handle;
> +
> +	if (!skb)
> +		return;
> +
> +	advmon_skb_len = (sizeof(struct mgmt_ev_adv_monitor_device_found) -
> +			  sizeof(struct mgmt_ev_device_found)) + skb->len;
> +	advmon_skb = mgmt_alloc_skb(hdev, MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
> +				    advmon_skb_len);
> +	if (!advmon_skb)
> +		return;
> +
> +	/* ADV_MONITOR_DEVICE_FOUND is similar to DEVICE_FOUND event except
> +	 * that it also has 'monitor_handle'. Make a copy of DEVICE_FOUND and
> +	 * store monitor_handle of the matched monitor.
> +	 */
> +	monitor_handle = skb_put(advmon_skb, sizeof(*monitor_handle));
> +	*monitor_handle = cpu_to_le16(handle);
> +	skb_put_data(advmon_skb, skb->data, skb->len);
> +
> +	mgmt_event_skb(advmon_skb, skip_sk);
> +}
> +

However, this is rather hackish code. It will blow up in our faces at some point and we will spent weeks to find the bug.

I realized that you already got this pattern merged by Luiz and that is why I merged your patch. I would have not accepted this in the first place. Maybe you need to spent some development cycles and check how all DEVICE_FOUND events can be properly generalized.

Regards

Marcel

