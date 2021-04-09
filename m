Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB5359C1A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhDIK3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:29:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40030 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhDIK3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:29:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUoOC-0000EC-Kv; Fri, 09 Apr 2021 10:29:24 +0000
From:   Colin Ian King <colin.king@canonical.com>
Subject: cnic: issue with double assignment to
 ictx->xstorm_st_context.common.flags
To:     Vladislav Zolotarov <vladz@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>
Cc:     "David S. Miller" <davem@conan.davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <45fd66c6-764b-bc0d-7ff9-920db399f11b@canonical.com>
Date:   Fri, 9 Apr 2021 11:29:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Analysis of linux with Coverity has detected an issue with the
assignment of ictx->xstorm_st_context.common.fla in
drivers/net/ethernet/broadcom/cnic.c in function cnic_setup_bnx2x_ctx.

This was introduced a while back with the following commit:

commit 619c5cb6885b936c44ae1422ef805b69c6291485
Author: Vlad Zolotarov <vladz@broadcom.com>
Date:   Tue Jun 14 14:33:44 2011 +0300

    New 7.0 FW: bnx2x, cnic, bnx2i, bnx2fc

The static analysis is as follows:

1761        ictx->xstorm_st_context.common.flags =

Unused value (UNUSED_VALUE)assigned_value: Assigning value 1 to
ictx->xstorm_st_context.common.flags here, but that stored value is
overwritten before it can be used.

1762                1 <<
XSTORM_COMMON_CONTEXT_SECTION_PHYSQ_INITIALIZED_SHIFT;
1763        ictx->xstorm_st_context.common.flags =

    value_overwrite: Overwriting previous write to
ictx->xstorm_st_context.common.flags with value from port << 1.

1764                port << XSTORM_COMMON_CONTEXT_SECTION_PBF_PORT_SHIFT;
1765
1766        ictx->tstorm_st_context.iscsi.hdr_bytes_2_fetch =
ISCSI_HEADER_SIZE;

The re-assignment of ictx->xstorm_st_context.common.flags in line 1763
is overwriting the value assigned on line 1761.  Should the = operator
on the re-assignment be an |= operator instead?

Colin
