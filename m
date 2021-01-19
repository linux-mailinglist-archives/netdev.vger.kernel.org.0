Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF662FC464
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbhASXFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:05:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:40803 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727291AbhASXEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 18:04:55 -0500
IronPort-SDR: QKF6yDUXzWF5mTY50IFaMZlAPPM1vLGwNQdRbu9LgAdaUcFpNqg1H/vNPxXocOIlnZddrCnJD6
 A5DjoITpX6tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="176439659"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="176439659"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 15:03:53 -0800
IronPort-SDR: Mc++cM/RBl4fQ/xQyf2JcwRT2PysywenJYxgzI3JLFumlR+DIRVw2ujfawhj7trULLkvauRgQx
 ori/nACfGl/Q==
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="355813109"
Received: from vdusetty-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.124.138])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 15:03:51 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 1/8] ethtool: Add support for configuring
 frame preemption
In-Reply-To: <20210119005224.yqrpyr2d7xawhbtf@skbuf>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
 <20210119004028.2809425-2-vinicius.gomes@intel.com>
 <20210119005224.yqrpyr2d7xawhbtf@skbuf>
Date:   Tue, 19 Jan 2021 15:03:42 -0800
Message-ID: <87v9bszfzl.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Mon, Jan 18, 2021 at 04:40:21PM -0800, Vinicius Costa Gomes wrote:
>> +int ethnl_set_preempt(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct ethnl_req_info req_info = {};
>> +	struct nlattr **tb = info->attrs;
>> +	struct ethtool_fp preempt = {};
>> +	struct net_device *dev;
>> +	bool mod = false;
>> +	int ret;
>> +
>> +	ret = ethnl_parse_header_dev_get(&req_info,
>> +					 tb[ETHTOOL_A_PREEMPT_HEADER],
>> +					 genl_info_net(info), info->extack,
>> +					 true);
>> +	if (ret < 0)
>> +		return ret;
>> +	dev = req_info.dev;
>> +	ret = -EOPNOTSUPP;
>> +	if (!dev->ethtool_ops->get_preempt ||
>> +	    !dev->ethtool_ops->set_preempt)
>> +		goto out_dev;
>> +
>> +	rtnl_lock();
>
> I'm a bit of a noob when it comes to ethtool (netlink or otherwise).
> Why do you take the rtnl_mutex when updating some purely hardware
> values, what netdev state is there to protect? Can this get->modify->set
> sequence be serialized using other locking mechanism than rtnl_mutex?

From what I understand, configuration changes to netdevice should be
protected by rtnl_mutex, for example, to avoid the device disappearing
while the configuration is in progress. I don't think there's any other
finer grained lock that can be used here.


Cheers,
-- 
Vinicius
