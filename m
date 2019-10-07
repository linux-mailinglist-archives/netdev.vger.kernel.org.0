Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C8BCE84A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfJGPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:51:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727711AbfJGPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:51:06 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x97FRTWm112983;
        Mon, 7 Oct 2019 11:51:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vg79gjq2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 11:51:03 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x97FSNM9121227;
        Mon, 7 Oct 2019 11:51:02 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vg79gjq21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 11:51:02 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x97FnrjH003970;
        Mon, 7 Oct 2019 15:51:01 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2vejt6j6bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 15:51:01 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x97Fp0C137552418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Oct 2019 15:51:00 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8DBDC6055;
        Mon,  7 Oct 2019 15:51:00 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FDDFC6057;
        Mon,  7 Oct 2019 15:51:00 +0000 (GMT)
Received: from [9.53.179.215] (unknown [9.53.179.215])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Oct 2019 15:51:00 +0000 (GMT)
Subject: Re: [RFC PATCH] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, zdai@us.ibm.com,
        David Miller <davem@davemloft.net>
In-Reply-To: <CAKgT0Ud7SupVd3RQmTEJ8e0fixiptS-1wFg+8V4EqpHEuAC3wQ@mail.gmail.com>
References: <1570208647.1250.55.camel@oc5348122405>
         <20191004233052.28865.1609.stgit@localhost.localdomain>
         <1570241926.10511.7.camel@oc5348122405>
         <CAKgT0Ud7SupVd3RQmTEJ8e0fixiptS-1wFg+8V4EqpHEuAC3wQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 07 Oct 2019 10:50:59 -0500
Message-ID: <1570463459.1510.5.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-07_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910070152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-05 at 10:22 -0700, Alexander Duyck wrote:
> On Fri, Oct 4, 2019 at 7:18 PM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
> >
> > On Fri, 2019-10-04 at 16:36 -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >
> > > This patch is meant to address possible race conditions that can exist
> > > between network configuration and power management. A similar issue was
> > > fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> > > netif_device_detach").
> > >
> > > In addition it consolidates the code so that the PCI error handling code
> > > will essentially perform the power management freeze on the device prior to
> > > attempting a reset, and will thaw the device afterwards if that is what it
> > > is planning to do. Otherwise when we call close on the interface it should
> > > see it is detached and not attempt to call the logic to down the interface
> > > and free the IRQs again.
> > >
> > > >From what I can tell the check that was adding the check for __E1000_DOWN
> > > in e1000e_close was added when runtime power management was added. However
> > > it should not be relevant for us as we perform a call to
> > > pm_runtime_get_sync before we call e1000_down/free_irq so it should always
> > > be back up before we call into this anyway.
> > >
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > ---
> > >
> > > I'm putting this out as an RFC for now. I haven't had a chance to do much
> > > testing yet, but I have verified no build issues, and the driver appears
> > > to load, link, and pass traffic without problems.
> > >
> > > This should address issues seen with either double freeing or never freeing
> > > IRQs that have been seen on this and similar drivers in the past.
> > >
> > > I'll submit this formally after testing it over the weekend assuming there
> > > are no issues.
> > >
> > >  drivers/net/ethernet/intel/e1000e/netdev.c |   33 ++++++++++++++--------------
> > >  1 file changed, 17 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > > index d7d56e42a6aa..182a2c8f12d8 100644
> > > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> 
> <snip>
> 
> > >
> > > -#ifdef CONFIG_PM_SLEEP
> > >  static int e1000e_pm_thaw(struct device *dev)
> > >  {
> > >       struct net_device *netdev = dev_get_drvdata(dev);
> > >       struct e1000_adapter *adapter = netdev_priv(netdev);
> > > +     int rc = 0;
> > >
> > >       e1000e_set_interrupt_capability(adapter);
> > > -     if (netif_running(netdev)) {
> > > -             u32 err = e1000_request_irq(adapter);
> > >
> > > -             if (err)
> > > -                     return err;
> > > +     rtnl_lock();
> > > +     if (netif_running(netdev)) {
> > > +             rc = e1000_request_irq(adapter);
> > > +             if (rc)
> > > +                     goto err_irq;
> > >
> > >               e1000e_up(adapter);
> > >       }
> > >
> > >       netif_device_attach(netdev);
> > > -
> > > -     return 0;
> > > +     rtnl_unlock();
> > > +err_irq:
> > > +     return rc;
> > >  }
> > >
> > In e1000e_pm_thaw(), these 2 lines need to switch order to avoid
> > deadlock.
> > from:
> > +       rtnl_unlock();
> > +err_irq:
> >
> > to:
> > +err_irq:
> > +       rtnl_unlock();
> >
> > I will find hardware to test this patch next week. Will update the test
> > result later.
> >
> > Thanks! - David
> 
> Thanks for spotting that. I will update my copy of the patch for when
> I submit the final revision.
> 
> I'll probably wait to submit it for acceptance until you have had a
> chance to verify that it resolves the issue you were seeing.
> 
> Thanks.
> 
> - Alex
We have tested on one of the test box.
With this patch, it doesn't crash kernel anymore, which is good!

However we see this warning message from the log file for irq number 0:
[10206.317270] Trying to free already-free IRQ 0

With this stack:
[10206.317344] NIP [c00000000018cbf8] __free_irq+0x308/0x370
[10206.317346] LR [c00000000018cbf4] __free_irq+0x304/0x370
[10206.317347] Call Trace:
[10206.317348] [c00000008b92b970] [c00000000018cbf4] __free_irq
+0x304/0x370 (unreliable)
[10206.317351] [c00000008b92ba00] [c00000000018cd84] free_irq+0x84/0xf0
[10206.317358] [c00000008b92ba30] [d000000007449e60] e1000_free_irq
+0x98/0xc0 [e1000e]
[10206.317365] [c00000008b92ba60] [d000000007458a70] e1000e_pm_freeze
+0xb8/0x100 [e1000e]
[10206.317372] [c00000008b92baa0] [d000000007458b6c]
e1000_io_error_detected+0x34/0x70 [e1000e]
[10206.317375] [c00000008b92bad0] [c000000000040358] eeh_report_failure
+0xc8/0x190
[10206.317377] [c00000008b92bb20] [c00000000003eb2c] eeh_pe_dev_traverse
+0x9c/0x170
[10206.317379] [c00000008b92bbb0] [c000000000040d84]
eeh_handle_normal_event+0xe4/0x580
[10206.317382] [c00000008b92bc60] [c000000000041330] eeh_handle_event
+0x30/0x340
[10206.317384] [c00000008b92bd10] [c000000000041780] eeh_event_handler
+0x140/0x200
[10206.317386] [c00000008b92bdc0] [c0000000001397c8] kthread+0x1a8/0x1b0
[10206.317389] [c00000008b92be30] [c00000000000b560]
ret_from_kernel_thread+0x5c/0x7c

Thanks! - David

