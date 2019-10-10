Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3579D2600
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfJJJNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:13:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:43954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733250AbfJJJNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:13:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B9B7B061;
        Thu, 10 Oct 2019 09:13:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 34DE4E378C; Thu, 10 Oct 2019 11:13:47 +0200 (CEST)
Date:   Thu, 10 Oct 2019 11:13:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] genetlink: do not parse attributes for families
 with zero maxattr
Message-ID: <20191010091347.GA22163@unicorn.suse.cz>
References: <20191009164432.AD5D1E3785@unicorn.suse.cz>
 <20191010083958.GD2223@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010083958.GD2223@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 10:39:58AM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 06:44:32PM CEST, mkubecek@suse.cz wrote:
> >Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
> >to a separate function") moved attribute buffer allocation and attribute
> >parsing from genl_family_rcv_msg_doit() into a separate function
> >genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
> >__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
> >parsing). The parser error is ignored and does not propagate out of
> >genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
> >type") is set in extack and if further processing generates no error or
> >warning, it stays there and is interpreted as a warning by userspace.
> >
> >Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
> >the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
> >same also in genl_family_rcv_msg_doit().
> 
> This is the original code before the changes:
> 
>         if (ops->doit == NULL)
>                 return -EOPNOTSUPP;
> 
>         if (family->maxattr && family->parallel_ops) {
>                 attrbuf = kmalloc_array(family->maxattr + 1,
>                                         sizeof(struct nlattr *),
>                                         GFP_KERNEL);
>                 if (attrbuf == NULL)
>                         return -ENOMEM;
>         } else
>                 attrbuf = family->attrbuf;
> 
>         if (attrbuf) {
>                 enum netlink_validation validate = NL_VALIDATE_STRICT;
> 
>                 if (ops->validate & GENL_DONT_VALIDATE_STRICT)
>                         validate = NL_VALIDATE_LIBERAL;
> 
>                 err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
>                                     family->policy, validate, extack);
>                 if (err < 0)
>                         goto out;
>         }
> 
> Looks like the __nlmsg_parse() is called no matter if maxattr if 0 or
> not. It is only considered for allocation of attrbuf. This is in-sync
> with the current code.

If family->maxattr is 0, genl_register_family() sets family->attrbuf to
NULL so that attrbuf is also NULL and the whole "if (attrbuf) { ... }"
block is not executed.

Michal
