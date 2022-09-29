Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24E5F0176
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 01:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiI2XiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 19:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiI2XiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 19:38:17 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D0214C062;
        Thu, 29 Sep 2022 16:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f7WrZuRB2GX0P+1NfkIg4YGL4fmYDCdScdWAGuAPgzc=; b=eP4G/3SzWgOlPrSUKmlI9aNrCR
        4rACRsmYEJ6uMECWrySSKj8fMonyU0DVvv70pYZIYb0JlLsCpPQSER+gHFMJQzJD0meT4GGrUFG4c
        IshwHvMxaie7wdpK7pDPnR724hijO8//B6KYNx+xUO6IX8zorTfSI7SnAZ6AcHKEafgAfBNaXGAcH
        XvXsp1vBNgD1Bl9mqzUfljEFgpr9wSAyCz6WsupjgupJI9DBiDSmneAkwqUXTq4MgXc+oBFb8Sydu
        Aa3M7KqRQWPZmgxu+Sivk6+zWQR6BjDt1MU/1PIVbmd8laLiRHL5WVwvVVYMcBbQFrOnZOMIiTzqV
        HGsZvZhw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oe36W-005937-0h;
        Thu, 29 Sep 2022 23:38:08 +0000
Date:   Fri, 30 Sep 2022 00:38:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Message-ID: <YzYsYK7pWo0RQXaw@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
 <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
 <YzYK7k3tgZy3Pwht@ZenIV>
 <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
 <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 05:48:29PM -0500, Eric W. Biederman wrote:

> +static const char *proc_net_symlink_get_link(struct dentry *dentry,
> +					     struct inode *inode,
> +					     struct delayed_call *done)
> +{
> +	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
> +	pid_t tid = task_pid_nr_ns(current, ns);
> +	char *name;
> +
> +	if (!tid)
> +		return ERR_PTR(-ENOENT);
> +	name = kmalloc(10 + 4 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
> +	if (unlikely(!name))
> +		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
> +	sprintf(name, "%u/net", tid);
> +	set_delayed_call(done, kfree_link, name);
> +	return name;
> +}

Just to troll adobriyan a bit:

static const char *dynamic_get_link(struct delayed_call *done,
				    bool is_rcu,
				    const char *fmt, ...)
{
	va_list args;
	char *body;

	va_start(args, fmt);
	body = kvasprintf(is_rcu ? GFP_ATOMIC : GFP_KERNEL, fmt, args);
	va_end(args);

	if (unlikely(!body))
		return is_rcu ? ERR_PTR(-ECHILD) : ERR_PTR(-ENOMEM);
	set_delayed_call(done, kfree_link, body);
	return body;
}

static const char *proc_net_symlink_get_link(struct dentry *dentry,
					     struct inode *inode,
					     struct delayed_call *done)
{
	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
	pid_t tid = task_pid_nr_ns(current, ns);

	if (!tid)
		return ERR_PTR(-ENOENT);
	return dyname_get_link(done, !dentry, "%u/net", tid);
}

static const char *proc_self_get_link(struct dentry *dentry,
				      struct inode *inode,
				      struct delayed_call *done)
{
	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
	pid_t tgid = task_tgid_nr_ns(current, ns);

	if (!tgid)
		return ERR_PTR(-ENOENT);
	return dynamic_get_link(done, !dentry, "%u", tgid);
}

static const char *proc_thread_self_get_link(struct dentry *dentry,
					     struct inode *inode,
					     struct delayed_call *done)
{
	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
	pid_t tgid = task_tgid_nr_ns(current, ns);
	pid_t pid = task_pid_nr_ns(current, ns);

	if (!pid)
		return ERR_PTR(-ENOENT);
	return dynamic_get_link(done, !dentry, "%u/task/%u", tgid, pid);
}
