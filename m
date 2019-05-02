Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93DF11ED0
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfEBPkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:40:43 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59304 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfEBP3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:29:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMDdr-0006zB-2J; Thu, 02 May 2019 17:28:59 +0200
Message-ID: <d0cfa4c1a17c336f1ad48a31897787469c302092.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/3] genetlink: do not validate dump requests
 if there is no policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>, Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 02 May 2019 17:28:57 +0200
In-Reply-To: <fd3b0c89-2475-166d-e2b8-1479af7b79bc@gmail.com> (sfid-20190502_153641_028378_FAA2A3FF)
References: <cover.1556798793.git.mkubecek@suse.cz>
         <0a54a4db49c20e76a998ea3e4548b22637fbad34.1556798793.git.mkubecek@suse.cz>
         <031933f3fc4b26e284912771b480c87483574bea.camel@sipsolutions.net>
         <20190502131023.GD21672@unicorn.suse.cz>
         <ab9b48a0e21d0a9e5069045c23db36f43e4356e3.camel@sipsolutions.net>
         <20190502133231.GF21672@unicorn.suse.cz>
         <fd3b0c89-2475-166d-e2b8-1479af7b79bc@gmail.com>
         (sfid-20190502_153641_028378_FAA2A3FF)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-05-02 at 07:36 -0600, David Ahern wrote:
> On 5/2/19 7:32 AM, Michal Kubecek wrote:
> > Wouldn't it mean effecitvely ending up with only one command (in
> > genetlink sense) and having to distinguish actual commands with
> > atributes? Even if I wanted to have just "get" and "set" command, common
> > policy wouldn't allow me to say which attributes are allowed for each of
> > them.
> 
> yes, I have been stuck on that as well.
> 
> There are a number of RTA attributes that are only valid for GET
> requests or only used in the response or only valid in NEW requests.
> Right now there is no discriminator when validating policies and the
> patch set to expose the policies to userspace

Yeah. As I've been discussing with Pablo in various threads recently,
this is definitely something we're missing.

As I said there though, I think it's something we should treat as
orthogonal to the policies.

I haven't looked at your ethtool patches really now (if you have a git
tree that'd be nice), but I saw e.g.

+When appropriate, network device is identified by a nested attribute named
+ETHA_*_DEV. This attribute can contain
+
+    ETHA_DEV_INDEX	(u32)		device ifindex
+    ETHA_DEV_NAME	(string)	device name

Presumably, this is valid for each and every command, right?

I'm not sure I understand the "ETHA_*_DEV" part, but splitting the
policy per command means that things like this that are available/valid
for each command need to be stated over and over again. This opens up
the very easy possibility that you have one command that takes an
ETHA_DEV_INDEX as u32, and another that - for some reason - takes a u64
for example, or similar confusion between the same attribute stated in
different policies.

This is why I believe that when we have a flat namespace for attributes,
like ETHA_*, we should also have a flat policy for those attributes, and
that's why I made the genetlink to have a single policy.

At the same time, I do realize that this is not ideal. So far I've sort
of pushed this to be something that we should treat orthogonally to the
validation for the above reasons, i.e. *not* state this specifically in
the policy.

If we were able to express this in C, I'd probably say we should have
something like

static const struct genl_ops ops[] = {
        {
                .cmd = MY_CMD,
                .doit = my_cmd_doit,
		.valid_attrs = { MY_ATTR_A, MY_ATTR_B },
        },

	...
};

However, there's no way to express this in C code, except for

static const u16 my_cmd_valid_attrs[] = { MY_ATTR_A, MY_ATTR_B, 0 };

static const struct genl_ops ops[] = {
        {
                .cmd = MY_CMD,
                .doit = my_cmd_doit,
		.valid_attrs = my_cmd_valid_attrs,
        },

	...
};

which is clearly ugly to write. We could generate this code from a
domain-specific language like Pablo suggested, but I'm not really sure
that's ideal either.


Regardless, I think we should solve this problem orthogonally from the
policy, given that otherwise we can end up with the same attribute
meaning different things in different commands.

johannes

