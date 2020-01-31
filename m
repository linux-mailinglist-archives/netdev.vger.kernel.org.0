Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA914F1C5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgAaSEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:04:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:64774 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:04:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:04:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="430443301"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2020 10:04:23 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v2 1/3] taprio: Fix enabling offload with wrong number of traffic classes
In-Reply-To: <20200129.111116.26679152804758998.davem@davemloft.net>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com> <20200128235227.3942256-2-vinicius.gomes@intel.com> <20200129.111116.26679152804758998.davem@davemloft.net>
Date:   Fri, 31 Jan 2020 10:05:44 -0800
Message-ID: <87lfpnbix3.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

David Miller <davem@davemloft.net> writes:

> This feedback applies to the existing code too, but don't we need to have
> a call to netdev_reset_tc() in the error paths after we commit these
> settings?
>
> Because ->num_tc for the device should be reset to zero for sure if we
> can't complete this configuration change successfully.

As we can only change ->num_tc in the _init() path, if any error happens,
_init() will fail and taprio_destroy() will be called, reseting num_tc to
zero.

And, yeah, in taprio_destoy() calling netdev_reset_tc() is better than
netdev_set_num_tc(dev, 0). Will fix this.


Cheers,
--
Vinicius
