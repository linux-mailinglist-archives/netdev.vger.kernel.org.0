Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8CF2175
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732653AbfKFWP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:15:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727023AbfKFWP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:15:27 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA6LmJkt080758;
        Wed, 6 Nov 2019 17:14:05 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w45r0a420-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 17:14:04 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA6ME3tb014391;
        Wed, 6 Nov 2019 22:14:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 2w41ujaads-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 22:14:04 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA6ME30B40763656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 22:14:03 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFE9EB2696;
        Wed,  6 Nov 2019 22:14:03 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 930B8B2694;
        Wed,  6 Nov 2019 22:14:03 +0000 (GMT)
Received: from localhost (unknown [9.41.179.251])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  6 Nov 2019 22:14:03 +0000 (GMT)
From:   Nathan Lynch <nathanl@linux.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, tyreld@linux.ibm.com, msuchanek@suse.com,
        linuxppc-dev@ozlabs.org
Subject: Re: [RFC PATCH] powerpc/pseries/mobility: notify network peers after migration
In-Reply-To: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
Date:   Wed, 06 Nov 2019 16:14:03 -0600
Message-ID: <87lfss7ivo.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911060211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

Thomas Falcon <tlfalcon@linux.ibm.com> writes:
> After a migration, it is necessary to send a gratuitous ARP
> from all running interfaces so that the rest of the network
> is aware of its new location. However, some supported network
> devices are unaware that they have been migrated. To avoid network
> interruptions and other unwanted behavior, force a GARP on all
> valid, running interfaces as part of the post_mobility_fixup
> routine.

[...]

> @@ -331,6 +334,8 @@ void post_mobility_fixup(void)
>  {
>  	int rc;
>  	int activate_fw_token;
> +	struct net_device *netdev;
> +	struct net *net;
>  
>  	activate_fw_token = rtas_token("ibm,activate-firmware");
>  	if (activate_fw_token == RTAS_UNKNOWN_SERVICE) {
> @@ -371,6 +376,21 @@ void post_mobility_fixup(void)
>  	/* Possibly switch to a new RFI flush type */
>  	pseries_setup_rfi_flush();
>  
> +	/* need to force a gratuitous ARP on running interfaces */
> +	rtnl_lock();
> +	for_each_net(net) {
> +		for_each_netdev(net, netdev) {
> +			if (netif_device_present(netdev) &&
> +			    netif_running(netdev) &&
> +			    !(netdev->flags & (IFF_NOARP | IFF_LOOPBACK)))
> +				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
> +							 netdev);
> +				call_netdevice_notifiers(NETDEV_RESEND_IGMP,
> +							 netdev);
> +		}
> +	}
> +	rtnl_unlock();
> +

This isn't an outright nak, but this is not nice. It illustrates the
need to rethink the pseries partition migration code. There is no
mechanism for drivers and other interested code to prepare for a
migration or to adjust to the destination. So post_mobility_fixup() will
continue to grow into a fragile collection of calls into unrelated
subsystems until there is a better design -- either a pseries-specific
notification/callback mechanism, or something based on the pm framework.

My understanding is that this is needed specifically for ibmveth and,
unlike ibmvnic, the platform does not provide any notification to that
driver that a migration has occurred, right?
