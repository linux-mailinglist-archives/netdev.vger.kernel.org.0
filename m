Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3974646FC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346822AbhLAGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:07:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:63793 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhLAGHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 01:07:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="223621185"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="223621185"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:04:19 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="677139324"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.35.160]) ([10.209.35.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:04:19 -0800
Message-ID: <2b178a0e-da00-8639-7779-ac5545f8e317@linux.intel.com>
Date:   Tue, 30 Nov 2021 22:04:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 04/14] net: wwan: t7xx: Add port proxy infrastructure
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
 <CAHNKnsSbrxXNhwaxD6PhpYni=jDy5F-_pn6nU9cprM5FCa3hug@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsSbrxXNhwaxD6PhpYni=jDy5F-_pn6nU9cprM5FCa3hug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/6/2021 11:06 AM, Sergey Ryazanov wrote:
> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> Port-proxy provides a common interface to interact with different types
>> of ports. Ports export their configuration via `struct t7xx_port` and
>> operate as defined by `struct port_ops`.
[skipped]
>
>> +       enum ccci_ch            tx_ch;
>> +       enum ccci_ch            rx_ch;
>> +       unsigned char           txq_index;
>> +       unsigned char           rxq_index;
>> +       unsigned char           txq_exp_index;
>> +       unsigned char           rxq_exp_index;
>> +       enum cldma_id           path_id;
>> +       unsigned int            flags;
>> +       struct port_ops         *ops;
>> +       unsigned int            minor;
>> +       char                    *name;
> Why did you need these two fields with the port name and minor number?
> The WWAN subsystem will care about these data for you. It is its
> purpose.

This port proxy structure can abstract different types of ports. 'minor' 
field is used for

tty and char ports but it will be removed since the next iteration will 
contain only

WWAN ports and one control port.

'name' is currently used when printing error logs,  in the future it can 
be used

to define the name in the file system for test and debug ports.


[skipped]

>> +static int proxy_register_char_dev(void)
>> +{
>> +       dev_t dev = 0;
>> +       int ret;
>> +
>> +       if (port_prox->major) {
>> +               dev = MKDEV(port_prox->major, port_prox->minor_base);
>> +               ret = register_chrdev_region(dev, TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
>> +       } else {
>> +               ret = alloc_chrdev_region(&dev, port_prox->minor_base,
>> +                                         TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
>> +               if (ret)
>> +                       dev_err(port_prox->dev, "failed to alloc chrdev region, ret=%d\n", ret);
>> +
>> +               port_prox->major = MAJOR(dev);
>> +       }
> For what do you need these character devices? The WWAN subsystem
> already handle all these tasks.
This infrastructure is not going to be included in the next iteration, 
it is used for debug and test ports.
>> +       return ret;
>> +}
>> ...
>> +static int proxy_alloc(struct mtk_modem *md)
>> +{
>> +       int ret;
>> +
>> +       port_prox = devm_kzalloc(&md->mtk_dev->pdev->dev, sizeof(*port_prox), GFP_KERNEL);
>> +       if (!port_prox)
>> +               return -ENOMEM;
>
[skipped]


Ricardo
