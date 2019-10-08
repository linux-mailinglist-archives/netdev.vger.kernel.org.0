Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A840ED0280
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 22:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfJHUt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 16:49:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46604 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730674AbfJHUt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 16:49:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x98KWluk121271;
        Tue, 8 Oct 2019 16:49:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vf98j073a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 16:49:48 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x98KWpYE121438;
        Tue, 8 Oct 2019 16:49:47 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vf98j0733-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 16:49:47 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x98KUpCc030366;
        Tue, 8 Oct 2019 20:49:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 2vejt6v6ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 20:49:46 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x98KnkuR7274896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Oct 2019 20:49:46 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EEF3AC05B;
        Tue,  8 Oct 2019 20:49:46 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF5C6AC059;
        Tue,  8 Oct 2019 20:49:45 +0000 (GMT)
Received: from [9.53.179.215] (unknown [9.53.179.215])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Oct 2019 20:49:45 +0000 (GMT)
Subject: Re: [RFC PATCH v2] e1000e: Use rtnl_lock to prevent race
 conditions between net and pci/pm
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        zdai@us.ibm.com, davem@davemloft.net
In-Reply-To: <20191007172559.11166.29328.stgit@localhost.localdomain>
References: <CAKgT0UdwqGGKvaSJ+3vd-_d-6t9MB=No+7SpkbOT2PnynRK+2w@mail.gmail.com>
         <20191007172559.11166.29328.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 08 Oct 2019 15:49:45 -0500
Message-ID: <1570567785.1510.12.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910080160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-07 at 10:27 -0700, Alexander Duyck wrote:
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
> RFC v2: Dropped some unused variables
> 	Added logic to check for device present before removing to pm_freeze
> 	Fixed misplaced err_irq to before rtnl_unlock()
> 
>  drivers/net/ethernet/intel/e1000e/netdev.c |   40 +++++++++++++++-------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e42a6aa..8b4e589aca36 100644
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
> @@ -6298,10 +6298,14 @@ static int e1000e_pm_freeze(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	bool present;
> 
> +	rtnl_lock();
> +
> +	present = netif_device_present(netdev);
>  	netif_device_detach(netdev);
> 
> -	if (netif_running(netdev)) {
> +	if (present && netif_running(netdev)) {
>  		int count = E1000_CHECK_RESET_COUNT;
> 
>  		while (test_bit(__E1000_RESETTING, &adapter->state) && count--)
> @@ -6313,6 +6317,8 @@ static int e1000e_pm_freeze(struct device *dev)
>  		e1000e_down(adapter, false);
>  		e1000_free_irq(adapter);
>  	}
> +	rtnl_unlock();
> +
>  	e1000e_reset_interrupt_capability(adapter);
> 
>  	/* Allow time for pending master requests to run */
> @@ -6626,27 +6632,31 @@ static int __e1000_resume(struct pci_dev *pdev)
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
> +err_irq:
> +	rtnl_unlock();
> 
> -	return 0;
> +	return rc;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
>  static int e1000e_pm_suspend(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -6818,16 +6828,11 @@ static void e1000_netpoll(struct net_device *netdev)
>  static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
>  						pci_channel_state_t state)
>  {
> -	struct net_device *netdev = pci_get_drvdata(pdev);
> -	struct e1000_adapter *adapter = netdev_priv(netdev);
> -
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
> @@ -6893,10 +6898,7 @@ static void e1000_io_resume(struct pci_dev *pdev)
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
> 
Tested this v2 version patch. There is no more crash, which is good.
And It also eliminates the double free warning message.
This patch is good to go.

Thanks! - David

