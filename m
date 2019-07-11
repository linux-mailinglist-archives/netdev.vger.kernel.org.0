Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA564FED
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfGKBdH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 21:33:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2482 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727708AbfGKBdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 21:33:07 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id D17612CC9601704C2F8C;
        Thu, 11 Jul 2019 09:33:04 +0800 (CST)
Received: from DGGEMM507-MBX.china.huawei.com ([169.254.1.169]) by
 DGGEMM404-HUB.china.huawei.com ([10.3.20.212]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 09:32:57 +0800
From:   Nixiaoming <nixiaoming@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "Nadia.Derbey@bull.net" <Nadia.Derbey@bull.net>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "semen.protsenko@linaro.org" <semen.protsenko@linaro.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "vvs@virtuozzo.com" <vvs@virtuozzo.com>,
        "Huangjianhui (Alex)" <alex.huangjianhui@huawei.com>,
        Dailei <dylix.dailei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Thread-Topic: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Thread-Index: AQHVNszeCdZobq+tm0y9Gm/hoQ9GDabC1LcAgAHObtA=
Date:   Thu, 11 Jul 2019 01:32:57 +0000
Message-ID: <E490CD805F7529488761C40FD9D26EF12AC9D039@dggemm507-mbx.china.huawei.com>
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
 <20190710055628.GB5778@kroah.com>
In-Reply-To: <20190710055628.GB5778@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.57.88.168]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, July 10, 2019 1:56 PM Greg KH wrote:
>On Wed, Jul 10, 2019 at 11:09:07AM +0800, Xiaoming Ni wrote:
>> Registering the same notifier to a hook repeatedly can cause the hook
>> list to form a ring or lose other members of the list.
>
>Then don't do that :)
>

Duplicate registration is checked and exited in notifier_chain_cond_register()

Duplicate registration was checked in notifier_chain_register() but only 
the alarm was triggered without exiting. added by commit 831246570d34692e 
("kernel/notifier.c: double register detection")

This patch is similar to commit 8312465 and notifier_chain_cond_register(),
 with actual prevention for such behaviour,  which I think is necessary to 
 avoid the formation of a linked list ring.

>Is there any in-kernel users that do do this?  If so, please just fix
>them.
>
Notifier_chain_register() is not a hotspot path.
Adding a check here can make the kernel more stable.

Thanks

Xiaoming Ni


>thanks,
>
>greg k-h
>
