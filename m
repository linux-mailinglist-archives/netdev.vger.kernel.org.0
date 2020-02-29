Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F334B1743CF
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB2Adl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:33:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:5255 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB2Adl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 19:33:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 16:33:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="232694615"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.87]) ([134.134.177.87])
  by fmsmga008.fm.intel.com with ESMTP; 28 Feb 2020 16:33:40 -0800
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
Subject: ip link vf info truncating with many VFs
Organization: Intel Corporation
Message-ID: <16b289f6-b025-5dd3-443d-92d4c167e79c@intel.com>
Date:   Fri, 28 Feb 2020 16:33:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I recently noticed an issue in the rtnetlink API for obtaining VF
information.

If a device creates 222 or more VF devices, the rtnl_fill_vf function
will incorrectly label the size of the IFLA_VFINFO_LIST attribute. This
occurs because rtnl_fill_vfinfo will have added more than 65k (maximum
size of a single attribute since nla_len is a __u16).

This causes the calculation in nla_nest_end to overflow and report a
significantly shorter length value. Worse case, with 222 VFs, the "ip
link show <device>" reports no VF info at all.

For some reason, the nla_put calls do not trigger an EMSGSIZE error,
because the skb itself is capable of holding the data.

I think the right thing is probably to do some sort of
overflow-protected calculation and print a warning... or find a way to
fix nla_put to error with -EMSGSIZE if we would exceed the nested
attribute size limit... I am not sure how to do that at a glance.

Thanks,
Jake
