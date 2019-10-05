Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F7CC75F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 04:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfJECTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 22:19:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbfJECTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 22:19:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x952GZWv090570;
        Fri, 4 Oct 2019 22:18:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vehga91t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 22:18:56 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x952GYQK090530;
        Fri, 4 Oct 2019 22:18:56 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vehga91sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 22:18:55 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x952GFAo026481;
        Sat, 5 Oct 2019 02:18:55 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 2v9y597hg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Oct 2019 02:18:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x952Is8251577146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Oct 2019 02:18:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 045D778066;
        Sat,  5 Oct 2019 02:18:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAE497805E;
        Sat,  5 Oct 2019 02:18:52 +0000 (GMT)
Received: from [9.80.206.47] (unknown [9.80.206.47])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  5 Oct 2019 02:18:52 +0000 (GMT)
Subject: Re: [RFC PATCH] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        zdai@us.ibm.com, davem@davemloft.net
In-Reply-To: <20191004233052.28865.1609.stgit@localhost.localdomain>
References: <1570208647.1250.55.camel@oc5348122405>
         <20191004233052.28865.1609.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 04 Oct 2019 21:18:46 -0500
Message-ID: <1570241926.10511.7.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-05_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910050018
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-04 at 16:36 -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> This patch is meant to address possible race conditions that can exist
> between network configuration and power management. A similar issue was
> fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> netif_device_detach").
> 
> In addition it consolidates the code so that the PCI error handling code
> will essentially perform the power management freeze on the device prior to
> attempting a reset, and will thaw the device afterwards if that is what it
> is planning to do. Otherwise when we call close on the interface it should
> see it is detached and not attempt to call the logic to down the interface
> and free the IRQs again.
> 
> >From what I can tell the check that was adding the check for __E1000_DOWN
> in e1000e_close was added when runtime power management was added. However
> it should not be relevant for us as we perform a call to
> pm_runtime_get_sync before we call e1000_down/free_irq so it should always
> be back up before we call into this anyway.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
> 
> I'm putting this out as an RFC for now. I haven't had a chance to do much
> testing yet, but I have verified no build issues, and the driver appears
> to load, link, and pass traffic without problems.
> 
> This should address issues seen with either double freeing or never freeing
> IRQs that have been seen on this and similar drivers in the past.
> 
> I'll submit this formally after testing it over the weekend assuming there
> are no issues.
> 
>  drivers/net/ethernet/intel/e1000e/netdev.c |   33 ++++++++++++++--------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e42a6aa..182a2c8f12d8 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -4715,12 +4715,12 @@ int e1000e_close(struct net_device *netdev)
> 
>  	pm_runtime_get_sync(&pdev->dev);
> 
> -	if (!test_bit(__E1000_DOWN, &adapter->state)) {
> +	if (netif_device_present(netdev)) {
>  		e1000e_down(adapter, true);
>  		e1000_free_irq(adapter);
> 
>  		/* Link status message must follow this format */
> -		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
> +		pr_info("%s NIC Link is Down\n", netdev->name);
>  	}
> 
>  	napi_disable(&adapter->napi);
> @@ -6299,6 +6299,7 @@ static int e1000e_pm_freeze(struct device *dev)
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> 
> +	rtnl_lock();
>  	netif_device_detach(netdev);
> 
>  	if (netif_running(netdev)) {
> @@ -6313,6 +6314,8 @@ static int e1000e_pm_freeze(struct device *dev)
>  		e1000e_down(adapter, false);
>  		e1000_free_irq(adapter);
>  	}
> +	rtnl_unlock();
> +
>  	e1000e_reset_interrupt_capability(adapter);
> 
>  	/* Allow time for pending master requests to run */
> @@ -6626,27 +6629,30 @@ static int __e1000_resume(struct pci_dev *pdev)
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM_SLEEP
>  static int e1000e_pm_thaw(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	int rc = 0;
> 
>  	e1000e_set_interrupt_capability(adapter);
> -	if (netif_running(netdev)) {
> -		u32 err = e1000_request_irq(adapter);
> 
> -		if (err)
> -			return err;
> +	rtnl_lock();
> +	if (netif_running(netdev)) {
> +		rc = e1000_request_irq(adapter);
> +		if (rc)
> +			goto err_irq;
> 
>  		e1000e_up(adapter);
>  	}
> 
>  	netif_device_attach(netdev);
> -
> -	return 0;
> +	rtnl_unlock();
> +err_irq:
> +	return rc;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
>  static int e1000e_pm_suspend(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -6821,13 +6827,11 @@ static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
>  	struct net_device *netdev = pci_get_drvdata(pdev);
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> 
> -	netif_device_detach(netdev);
> +	e1000e_pm_freeze(&pdev->dev);
> 
>  	if (state == pci_channel_io_perm_failure)
>  		return PCI_ERS_RESULT_DISCONNECT;
> 
> -	if (netif_running(netdev))
> -		e1000e_down(adapter, true);
>  	pci_disable_device(pdev);
> 
>  	/* Request a slot slot reset. */
> @@ -6893,10 +6897,7 @@ static void e1000_io_resume(struct pci_dev *pdev)
> 
>  	e1000_init_manageability_pt(adapter);
> 
> -	if (netif_running(netdev))
> -		e1000e_up(adapter);
> -
> -	netif_device_attach(netdev);
> +	e1000e_pm_thaw(&pdev->dev);
> 
>  	/* If the controller has AMT, do not set DRV_LOAD until the interface
>  	 * is up.  For all other cases, let the f/w know that the h/w is now
In e1000e_pm_thaw(), these 2 lines need to switch order to avoid
deadlock.
from:
+       rtnl_unlock();
+err_irq:

to:
+err_irq:
+       rtnl_unlock();

I will find hardware to test this patch next week. Will update the test
result later.

Thanks! - David

