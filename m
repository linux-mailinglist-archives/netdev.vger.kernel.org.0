Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6C814F1B6
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgAaR6D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 12:58:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:30314 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaR6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 12:58:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 09:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="430440536"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2020 09:58:02 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vladimir.oltean@nxp.com,
        po.liu@nxp.com
Subject: Re: [PATCH net v3 2/2] taprio: Fix still allowing changing the flags during runtime
In-Reply-To: <20200131072656.0b899074@cakuba.hsd1.ca.comcast.net>
References: <20200130013721.33812-1-vinicius.gomes@intel.com> <20200130013721.33812-3-vinicius.gomes@intel.com> <20200131072656.0b899074@cakuba.hsd1.ca.comcast.net>
Date:   Fri, 31 Jan 2020 09:59:23 -0800
Message-ID: <87v9orbj7o.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 29 Jan 2020 17:37:21 -0800, Vinicius Costa Gomes wrote:
>> +static int taprio_new_flags(const struct nlattr *attr, u32 old,
>> +			    struct netlink_ext_ack *extack)
>> +{
>> +	u32 new = 0;
>
> TCA_TAPRIO_ATTR_FLAGS doesn't seem to be in the netlink policy 😖

Will add it.

>
>> +	if (attr)
>> +		new = nla_get_u32(attr);
>> +
>> +	if (old != TAPRIO_FLAGS_INVALID && old != new) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
>> +		return -ENOTSUPP;
>
> -EOPNOTSUPP

Will fix.

>
>> +	}
>> +
>> +	if (!taprio_flags_valid(new)) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return new;
>> +}
