Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C3A22C2A2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 11:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgGXJ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 05:57:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33686 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgGXJ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 05:57:41 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84A7020054;
        Fri, 24 Jul 2020 09:57:40 +0000 (UTC)
Received: from us4-mdac16-43.at1.mdlocal (unknown [10.110.48.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 831C5800A4;
        Fri, 24 Jul 2020 09:57:40 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2E41840060;
        Fri, 24 Jul 2020 09:57:40 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E58A14C0068;
        Fri, 24 Jul 2020 09:57:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 10:57:34 +0100
Subject: Re: [PATCH net-next v3 1/2] hinic: add support to handle hw abnormal
 event
To:     David Miller <davem@davemloft.net>, <luobin9@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200723144038.10430-1-luobin9@huawei.com>
 <20200723144038.10430-2-luobin9@huawei.com>
 <20200723.120852.1882569285026023193.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <92dac9af-8623-bd1e-7a4d-9d12671699ad@solarflare.com>
Date:   Fri, 24 Jul 2020 10:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200723.120852.1882569285026023193.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25560.003
X-TM-AS-Result: No-8.820400-8.000000-10
X-TMASE-MatchedRID: pBwXUM+nCwvmLzc6AOD8DfHkpkyUphL905gx+zrdgZaQzLINxjetpFbY
        KMhwSW1CNnZ1cmyQc4mPr625QdxYkvFR4E58OzUoIp8MIsmMqvtUENBIMyKD0Zsoi2XrUn/JyeM
        tMD9QOgADpAZ2/B/Blp1jVwOAgjOIavP8b9lJtWr6C0ePs7A07Q2y0JeZ/zscixCcHJ0l6L9U9V
        7w4C4apCDeObfXRMUe1Ur+PJUaME0VVZKExyWDBgcRwsRXSGo3rrPhI00pdvPwClow2+L85TI9C
        U2hgdVOUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD+kkf6HhPsBc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.820400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25560.003
X-MDID: 1595584660-TA2_liJbFgvR
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2020 20:08, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Thu, 23 Jul 2020 22:40:37 +0800
>
>> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
>> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	struct hinic_mgmt_watchdog_info *watchdog_info;
>> +	int err;
>> +
>> +	if (priv_ctx) {
>> +		watchdog_info = priv_ctx;
>> +		err = mgmt_watchdog_report_show(fmsg, watchdog_info);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>> +}
> This 'watchdog_info' variable is completely unnecessary, just pass
> 'priv_ctx' as-is into mgmt_watchdog_report_show().
Looks like the 'err' variable is unnecessary too...

-ed
