Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B154D2A97DD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 15:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgKFOsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 09:48:36 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41752 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgKFOsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 09:48:36 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A6Em8sP127578;
        Fri, 6 Nov 2020 08:48:08 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604674088;
        bh=9N+olG0dB7j/8fBZOe6ONr0tua14IvBdrcnQ69I+Bs4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Nj5rdViDb40Kk0WOrg3pFoVWIaqyRfRBB65qTH9ITLulUanF0egGa2PcLe4wEiGXw
         6bo6X2wCfE5tw8Y1wJD1GRG5lkIDpSCiQ5ArmdXysO2duntZQNJu/n1X3dZSooO4pF
         WIQfmfS9NsAH+JAd33eTqD+Yb0xFrDLs33qe9a4s=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A6Em76L092634
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Nov 2020 08:48:07 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 6 Nov
 2020 08:48:07 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 6 Nov 2020 08:48:07 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A6Em411090693;
        Fri, 6 Nov 2020 08:48:05 -0600
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Arnd Bergmann <arnd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
 <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
 <CAK8P3a0Dce3dYER0oJ+2FcV8UbJqCaAv7zSS6JZBdb6ewfnE7g@mail.gmail.com>
 <87pn4qmyl1.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <1301ecbe-0380-9744-04dc-7d133d598700@ti.com>
Date:   Fri, 6 Nov 2020 16:48:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87pn4qmyl1.fsf@kurt>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/11/2020 14:58, Kurt Kanzenbach wrote:
> On Fri Nov 06 2020, Arnd Bergmann wrote:
>> On Fri, Nov 6, 2020 at 12:35 PM Grygorii Strashko
>> <grygorii.strashko@ti.com> wrote:
>>> On 06/11/2020 09:56, Wang Qing wrote:
>>
>>>> +++ b/drivers/net/ethernet/ti/am65-cpts.c
>>>> @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>>>
>>> there is
>>>          cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
>>>
>>>
>>>>        if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
>>>
>>> And ptp_clock_register() can return NULL only if PTP support is disabled.
>>> In which case, we should not even get here.
>>>
>>> So, I'd propose to s/IS_ERR_OR_NULL/IS_ERR above,
>>> and just assign ret = PTR_ERR(cpts->ptp_clock) here.
>>
>> Right, using IS_ERR_OR_NULL() is almost ever a mistake, either
>> from misunderstanding the interface, or from a badly designed
>> interface that needs to be changed.
> 
> The NULL case should be handled differently and it is documented:
> 
> /**
>   * ptp_clock_register() - register a PTP hardware clock driver
> [...]
>   * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>   * support is missing at the configuration level, this function
>   * returns NULL, and drivers are expected to gracefully handle that
>   * case separately.
>   */

I think, it's not the first time such question triggered, I've found [1]

I've managed to find 6 drivers which uses IS_ERR_OR_NULL check with ptp_clock_register() and, kinda,
assume to be able to work with !CONFIG_PTP_1588_CLOCK. List below with some comments:

hv
hv_util.c
hv_timesync_init, line 697:  hv_ptp_clock = ptp_clock_register(&ptp_hyperv_info, NULL);

net/ethernet
sja1105 (depends on PTP_1588_CLOCK, use IS_ERR())
sja1105_ptp.c
sja1105_ptp_clock_register, line 867:  ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);

net/ethernet
chelsio (can be fixed by adding !IS_ENABLED(CONFIG_PTP_1588_CLOCK))
cxgb4
cxgb4_ptp.c
cxgb4_ptp_init, line 431:  adapter->ptp_clock = ptp_clock_register(&adapter->ptp_clock_info,

net/ethernet
octeontx2 (can be fixed by adding !IS_ENABLED(CONFIG_PTP_1588_CLOCK))
nic
otx2_ptp.c
otx2_ptp_init, line 170:  ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);

net/ethernet
renesas (no checks - will crash if init failed or !PTP), uses imply PTP_1588_CLOCK
ravb_ptp.c
ravb_ptp_init, line 345:  priv->ptp.clock = ptp_clock_register(&priv->ptp.info, &pdev->dev);

net/phy
mscc  (no checks - will crash if init failed or !PTP, depends on NETWORK_PHY_TIMESTAMPING)
mscc_ptp.c
__vsc8584_init_ptp, line 1495:  vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,

In general, if above updated, the return value for ptp_clock_register() can be changed to ERR_PTR(-EOPNOTSUPP)
for the !CONFIG_PTP_1588_CLOCK and so question resolved.

For hv/sja1105/cxgb4/octeontx2 below diff should solve the case, but I'm not sure about
renesas/ravb_ptp and net/phy/mscc.

For renesas/ravb_ptp - seems strict "depends on PTP_1588_CLOCK" can be the choice
For net/phy/mscc - seems code dependencies need to be changed from CONFIG_NETWORK_PHY_TIMESTAMPING to
CONFIG_PTP_1588_CLOCK.

[1] https://lore.kernel.org/lkml/c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com/
-- 
Best regards,
grygorii

-------------
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 05566ecdbe4b..0fa8f6cb2394 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -681,6 +681,11 @@ static struct ptp_clock *hv_ptp_clock;
  
  static int hv_timesync_init(struct hv_util_service *srv)
  {
+       int ret = 0;
+
+       if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
+               return -EOPNOTSUPP;
+
         /* TimeSync requires Hyper-V clocksource. */
         if (!hv_read_reference_counter)
                 return -ENODEV;
@@ -695,13 +700,13 @@ static int hv_timesync_init(struct hv_util_service *srv)
          * as it still handles the ICTIMESYNCFLAG_SYNC case.
          */
         hv_ptp_clock = ptp_clock_register(&ptp_hyperv_info, NULL);
-       if (IS_ERR_OR_NULL(hv_ptp_clock)) {
-               pr_err("cannot register PTP clock: %ld\n",
-                      PTR_ERR(hv_ptp_clock));
+       if (IS_ERR(hv_ptp_clock)) {
+               ret = PTR_ERR(hv_ptp_clock);
+               pr_err("cannot register PTP clock: %ld\n", ret);
                 hv_ptp_clock = NULL;
         }
  
-       return 0;
+       return ret;
  }
  
  static void hv_timesync_cancel_work(void)
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 1b90570b257b..1e41d491c854 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -865,7 +865,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
         spin_lock_init(&tagger_data->meta_lock);
  
         ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
-       if (IS_ERR_OR_NULL(ptp_data->clock))
+       if (IS_ERR(ptp_data->clock))
                 return PTR_ERR(ptp_data->clock);
  
         ptp_data->cmd.corrclk4ts = true;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 70dbee89118e..e43a3e73762b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -420,6 +420,10 @@ static const struct ptp_clock_info cxgb4_ptp_clock_info = {
  void cxgb4_ptp_init(struct adapter *adapter)
  {
         struct timespec64 now;
+
+       if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
+               return;
+
          /* no need to create a clock device if we already have one */
         if (!IS_ERR_OR_NULL(adapter->ptp_clock))
                 return;
@@ -430,7 +434,7 @@ void cxgb4_ptp_init(struct adapter *adapter)
  
         adapter->ptp_clock = ptp_clock_register(&adapter->ptp_clock_info,
                                                 &adapter->pdev->dev);
-       if (IS_ERR_OR_NULL(adapter->ptp_clock)) {
+       if (IS_ERR(adapter->ptp_clock)) {
                 adapter->ptp_clock = NULL;
                 dev_err(adapter->pdev_dev,
                         "PTP %s Clock registration has failed\n", __func__);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 7bcf5246350f..22b736c2e9d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -119,6 +119,9 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
         struct ptp_req *req;
         int err;
  
+       if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
+               return 0;
+
         mutex_lock(&pfvf->mbox.lock);
         /* check if PTP block is available */
         req = otx2_mbox_alloc_msg_ptp_op(&pfvf->mbox);
@@ -168,9 +171,8 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
         };
  
         ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);
-       if (IS_ERR_OR_NULL(ptp_ptr->ptp_clock)) {
-               err = ptp_ptr->ptp_clock ?
-                     PTR_ERR(ptp_ptr->ptp_clock) : -ENODEV;
+       if (IS_ERR(ptp_ptr->ptp_clock)) {
+               err = PTR_ERR(ptp_ptr->ptp_clock);
                 kfree(ptp_ptr);
                 goto error;
         }

