Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0FD4D6DFD
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiCLKZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiCLKZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:25:53 -0500
Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5217775A;
        Sat, 12 Mar 2022 02:24:47 -0800 (PST)
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4KFzSW2sKzzJS;
        Sat, 12 Mar 2022 11:24:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1647080684; bh=+QR/+RJkyH6iOL9WdEejK5XbutH1cp/++rV5+5TNCEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJup2gIGRswfLU52LqyF/nMo3l2iimuu1mZSzsQTuQKGumuX731elm4pQaQoiTA7R
         MP+HtyE9Dd01XZHadk64vHmOtW7A/XXhdC00IVxtKHeUwUMK+Wmays+UTb155qlIRr
         ERo2qs8gvRUeRgaHCGixncnt2KIuYg/0uqjni0UXn0NGN4a69IkL+NN0rhmhKXNWqn
         VXp1Uibi8oRExJlWeKWM1RGkoMm61+GyqDBjYs4Ua8u1U1J1yLdyzWv8L2e0pOKHBr
         9u5OEs+uczVfBM15y8Ps2Y7TkiyAyfEx917KnhoA0XXx6AnOvWUPIa7r4H4JgieC+1
         2XDC/8ptw0Fgg==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.5 at mail
Date:   Sat, 12 Mar 2022 11:24:40 +0100
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
Message-ID: <Yix06B9rPaGh0dp8@qmqm.qmqm.pl>
References: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
 <YiqPmIdZ/RGiaOei@qmqm.qmqm.pl>
 <CAADWXX-Pr-D3wSr5wsqTEOBSJzB9k7bSH+7hnCAj0AeL0=U4mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADWXX-Pr-D3wSr5wsqTEOBSJzB9k7bSH+7hnCAj0AeL0=U4mg@mail.gmail.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 04:46:33PM -0800, Linus Torvalds wrote:
> On Thu, Mar 10, 2022 at 3:54 PM Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> >
> > If the macro implementation doesn't have to be pretty, maybe it could go
> > a step further and remember the list_head's offset? That would look
> > something like following (expanding on your patch; not compile tested):
> 
> Oh, I thought of it.
> 
> It gets complicated.
[...]

It seems that it's not that bad if we don't require checking whether
a list_head of an entry is only ever used with a single list parent. The
source type is not needed for the macros, and it turns out that pre-declaring
the offset type is also not needed.

I compile-tested the code below on godbolt.org with -std=c11:

struct list_head {
	struct list_head *prev, *next;
};

#define offsetof __builtin_offsetof
#define typeof __typeof

#define list_traversal_head(name,type,target_member) \
	union { \
		struct list_head name; \
		type *name##_traversal_type; \
		char (*name##_list_head_offset)[offsetof(type, target_member)];  \
	}

#define self_list_ref_offset_type(type,target_member) \
	type##__##target_member##__offset__

#define define_self_list_ref_offset(type,target_member) \
	self_list_ref_offset_type(type,target_member) \
	{ char ignoreme__[offsetof(type, target_member)]; }

#define self_list_traversal_head(name,type,target_member) \
	union { \
		struct list_head name; \
		type *name##_traversal_type; \
		self_list_ref_offset_type(type,target_member) *name##_list_head_offset;  \
	}

#define list_traversal_entry(ptr, head) \
	(typeof(*head##_traversal_type))((void *)ptr - sizeof(**head##_list_head_offset))

#define list_traversal_entry_head(ptr, head) \
	((struct list_head *)((void *)ptr + sizeof(**head##_list_head_offset)))

#define list_traversal_entry_is_head(ptr, head) \
	(list_traversal_entry_head(ptr, head) == (head))

#define list_traversal_next_entry(ptr, head) \
	list_traversal_entry(list_traversal_entry_head(ptr, head)->next, head)

#define list_traverse(pos, head) \
    for (typeof(*head##_traversal_type) pos = list_traversal_entry((head)->next, head); \
    !list_traversal_entry_is_head(pos, head); \
    pos = list_traversal_next_entry(pos,head))

struct entry {
    self_list_traversal_head(self_list, struct entry, child_head);
    struct list_head child_head;
};

define_self_list_ref_offset(struct entry, child_head);


void bar(struct entry *b);

void foo(struct entry *a)
{
    list_traverse(pos, &a->self_list) {
        bar(pos);
    }
}

-- 
Micha³ Miros³aw
