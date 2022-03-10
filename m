Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EE94D5634
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345086AbiCKAA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345131AbiCKAAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:00:54 -0500
X-Greylist: delayed 339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 15:59:45 PST
Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2621EE02C9;
        Thu, 10 Mar 2022 15:59:44 -0800 (PST)
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4KF5WG2Pswz9q;
        Fri, 11 Mar 2022 00:54:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1646956443; bh=ZbM+uUpW63IdB++IxqwwUYhFJXACQMMNBE9FAmZwinc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=kIyR5n+l/hAW3FQWdIPuou+eqg0mMW5LgNePzkqwxnwkrJSckG4TPJkGwK1xSrTjW
         2d7SnTGSBkjBE5DCFm3+w5fAS33HffsMih9f+Lb6ETSfCSgi0Ri/lg/pbftAkVQwxB
         WsQpEtxuqsoaD+7Doj4Cpa9GnOl51kFUF57MI6fKEcXcRZ8JOopXSoFMkuaBhHKVud
         MUxq1sXw2E644SG6lRrCHSjzVYjr5bgwSklrSF4o1zY4BVEz6d1G0EJbMH3L9ZmFqh
         6s8x/e6xDV79LFHZGarq9eGUTUQPv8u+1OTFAaZ7dtmOMXIvXmBUurzi/xoy2rtkFw
         CnuvwD5HSkSYw==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.5 at mail
Date:   Fri, 11 Mar 2022 00:54:00 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
Message-ID: <YiqPmIdZ/RGiaOei@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

If the macro implementation doesn't have to be pretty, maybe it could go
a step further and remember the list_head's offset? That would look
something like following (expanding on your patch; not compile tested):

#define list_traversal_head(type,name,target_member) \
	union { \
		struct list_head name; \
		type *name##_traversal_type; \
		char (*name##_list_head_offset)[offsetof(type, target_member)];  \
	}

#define list_traversal_entry(ptr, head) \
	(typeof(*head##_traversal_type))((void *)ptr - sizeof(**head##_list_head_offset))

#define list_traversal_entry_head(ptr, head) \
	(struct list_head *)((void *)ptr + sizeof(**head##_list_head_offset))

#define list_traversal_entry_is_head(ptr, head) \
	(list_traversal_entry_head(ptr, head) == (head))

#define list_traversal_next_entry(ptr, head) \
	list_traversal_entry(list_traversal_entry_head(ptr, head)->next)

#define list_traverse(pos, head) \
	for (typeof(*head##_traversal_type) pos = list_traversal_entry((head)->next); \
		!list_traversal_entry_head(pos, head) == (head); \
		pos = list_traversal_next_entry(pos, head))

[Sorry for lack of citations - I found the thread via https://lwn.net/Articles/887097/]

-- 
Micha³ Miros³aw
