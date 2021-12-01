Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F24656C4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbhLAT4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:56:41 -0500
Received: from mail.cybernetics.com ([173.71.130.66]:44406 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245430AbhLAT4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:56:41 -0500
X-Greylist: delayed 751 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2021 14:56:40 EST
X-ASG-Debug-ID: 1638387647-0fb3b00bc441ca80001-BZBGGp
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 2zakT5jaHqlfcFho; Wed, 01 Dec 2021 14:40:47 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=9OyY8pB7p4lMlQj1B7S6jpFBpwPQkDgjX1Az/sdSvDE=;
        h=Content-Language:Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To; b=qW3i1D93HLjsSIZcZh2ZYDhNDf+EvmO2Rv763sORibWlbK/
        muof7Ut641bCZD/h+90o9SS4DsBbAtLjwqxgqt3m2Bqg79GNBHqgHzNpuXPfcsOqLEd8Yzglozlxz
        EFChqKR937UksNhIZftt+U45ALUbP8t28U5wz+51/uhLHmA=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 6.2.14)
  with ESMTPS id 11365671; Wed, 01 Dec 2021 14:40:47 -0500
To:     Tal Gilboa <talgi@nvidia.com>, netdev@vger.kernel.org
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
From:   Tony Battersby <tonyb@cybernetics.com>
Subject: dim_calc_stats() may cause uninitialized values to be used
Message-ID: <fb600754-30c9-2ff7-dc95-7f7fc4c7aefb@cybernetics.com>
X-ASG-Orig-Subj: dim_calc_stats() may cause uninitialized values to be used
Date:   Wed, 1 Dec 2021 14:40:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1638387647
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 743
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am reporting the following possible logic bug:

lib/dim/dim.c::dim_calc_stats() doesn't set curr_stats if delta_us == 0,
which would result in using uninitialized values in net_dim_decision()
and rdma_dim_decision().

I don't know anything about this code.  I encountered this only as a
compiler warning compiling an out-of-tree module that had a copy of
dim_calc_stats() inlined for compatibility with old kernels, and I
decided to investigate and report.  There is no compiler warning in
mainline since dim_calc_stats() and net_dim() are in separate C files so
the compiler can't fully analyze it, but it looks like mainline has the
problem also, if the delta_us == 0 condition is possible.

Tony Battersby
Cybernetics

