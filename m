Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0E11DC350
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgEUADE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:03:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:47915 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgEUADE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 20:03:04 -0400
IronPort-SDR: JiT38iOdWu7FD0EUWTTOFic0ARyQVtbv0yjDboJAprbQCLAMzYGV6a6ZmGx25c7jSvcsUgwYTs
 kc14PgrxcBbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 17:03:03 -0700
IronPort-SDR: em7B8k1f9l1EjO+715CKvOX1Q4AliQ7f8FVsTnfte+6fQPgLx87u6Q0X71k+9aaiEX2ZjiYaYe
 CnLJfxxa/rHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,415,1583222400"; 
   d="scan'208";a="308873453"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.4.230]) ([10.209.4.230])
  by FMSMGA003.fm.intel.com with ESMTP; 20 May 2020 17:03:03 -0700
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Subject: devlink interface for asynchronous event/messages from firmware?
Organization: Intel Corporation
Message-ID: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
Date:   Wed, 20 May 2020 17:03:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri, Jakub,

I've been asked to investigate using devlink as a mechanism for
reporting asynchronous events/messages from firmware including
diagnostic messages, etc.

Essentially, the ice firmware can report various status or diagnostic
messages which are useful for debugging internal behavior. We want to be
able to get these messages (and relevant data associated with them) in a
format beyond just "dump it to the dmesg buffer and recover it later".

It seems like this would be an appropriate use of devlink. I thought
maybe this would work with devlink health:

i.e. we create a devlink health reporter, and then when firmware sends a
message, we use devlink_health_report.

But when I dug into this, it doesn't seem like a natural fit. The health
reporters expect to see an "error" state, and don't seem to really fit
the notion of "log a message from firmware" notion.

One of the issues is that the health reporter only keeps one dump, when
what we really want is a way to have a monitoring application get the
dump and then store its contents.

Thoughts on what might make sense for this? It feels like a stretch of
the health interface...

I mean basically what I am thinking of having is using the devlink_fmsg
interface to just send a netlink message that then gets sent over the
devlink monitor socket and gets dumped immediately.

Thanks,
Jake
