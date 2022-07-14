Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343B1574EC2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiGNNOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiGNNOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:14:42 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726CF46D9C;
        Thu, 14 Jul 2022 06:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=XhHZFllZttK/nD0DghuHkAh2pYiQ6FVFXSwybTv29+M=; b=qMmQN49rflM5nNAbrtDJndAePo
        JkZBQa4twrJ30algsJoMebfheMEDj3dvPEMTjEs61ybh448PVs7S0+evyXujJGkfhp7wgK79OppbE
        cCooS75r3gjqj/ZScAe2awt8ja6AKbOT4KewCHmroR/G1/ijtcEN72ocsBK9ST6g7z/N825vnPwzc
        JOYlQY25cgg9yjfCbNn6Uq0ubwzMRXNUQS+QkE7WRJBB+X5wnhUASoqG4zGCxgillM9vUW+FsdPOQ
        CHM9C/bOghoqyPT+jjqxBWQ2cW5xzxp2tqHjc3ujH4SxkkQbk+ad6JzrWibSHcYDYN9BWQtXqB3P8
        m41ydZB/IdGkY+6AIu7TaMMKeDn+CSbJhCW0MpdZ0F/GbPv+Nk0jRny1sYD5T16Owx14keLT2KYZA
        plnf9k103TAWyYqoAm+NvkZ8XBNU8U+x5pnsLR1dX157HFtvGhuk3UqC7jet6yMfQ47VhizhWY6FJ
        VYCpzwf6nnyFzsuk7aXNhqaaq/eQgw2CrSGCP/UUcIrsVBnq/P/RhsAknlBv6SAtJxYJO/uIxLkaz
        rqxQhYNl/QKeGbgPZqjbxVIbASa5vd4SVYqAIq5zWFH7Th28K90znIIM/IzQF4uiee/j3MWXgba0E
        O6Xoocfx3t4MpX4rpyWgt8jiXFYI/Cf6unHSMamZE=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 10/11] net/9p: add p9_msg_buf_size()
Date:   Thu, 14 Jul 2022 15:14:31 +0200
Message-ID: <1784081.3E5Dq0oo6N@silver>
In-Reply-To: <Ys8wqPbA5eogtvmG@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com> <5564296.oo812IJUPE@silver>
 <Ys8wqPbA5eogtvmG@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 13. Juli 2022 22:52:56 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Wed, Jul 13, 2022 at 03:06:01PM +0200:
> > > > +	case P9_TWALK:
> > > > +		BUG_ON(strcmp("ddT", fmt));
> > > > +		va_arg(ap, int32_t);
> > > > +		va_arg(ap, int32_t);
> > > > +		{
> > > > +			uint i, nwname = max(va_arg(ap, int), 0);
> > > 
> > > I was about to say that the max is useless as for loop would be cut
> > > short, but these are unsigned... So the code in protocol.c p9pdu_vwritef
> > > 'T' has a bug (int cast directly to uint16): do you want to fix it or
> > > shall I go ahead?
> > 
> > I'd either send a separate patch today for fixing 'T', or if you want
> > to handle it by yourself, then just go ahead.
> 
> I'd appreciate if you have time, doesn't make much difference though

Looking closer at this separate issue; there is probably nothing to fix. 'T'
(and 'R') in p9pdu_vwritef() pulls an 'int' argument from the stack. But the
actual variable is passed here:

struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
			      const unsigned char * const *wnames, int clone)
{
    ...
    req = p9_client_rpc(clnt, P9_TWALK, "ddT", oldfid->fid, fid->fid,
                        nwname, wnames);
    ...
}

So the variable being passed was already uint16_t, which made me re-aware why
this is working anyway: Because C and C++ have this nice language hack that
any variadic integer variable smaller than 'int' is automatically casted to
'int' before being passed.

I mean I could clamp the pulled argument like:

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 3754c33e2974..5fd1e948c86a 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -441,7 +441,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
                        }
                        break;
                case 'T':{
-                               uint16_t nwname = va_arg(ap, int);
+                               uint16_t nwname = clamp_t(int, va_arg(ap, int), 0, USHRT_MAX);
                                const char **wnames = va_arg(ap, const char **);
 
                                errcode = p9pdu_writef(pdu, proto_version, "w",
@@ -462,7 +462,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
                        }
                        break;
                case 'R':{
-                               uint16_t nwqid = va_arg(ap, int);
+                               uint16_t nwqid = clamp_t(int, va_arg(ap, int), 0, USHRT_MAX);
                                struct p9_qid *wqids =
                                    va_arg(ap, struct p9_qid *);

But it's pretty much pointless overhead. Another option would be to change
va_arg(ap, int) -> va_arg(ap, uint16_t), just to make it more clear what was
pushed from the other side.

Which probably also means I can simply drop the max() call in this patch 10
here as well.

For the 'R' case: I haven't found the spot where this is actually used.

> > > > +	case P9_TCREATE:
> > > > +		BUG_ON(strcmp("dsdb?s", fmt));
> > > > +		va_arg(ap, int32_t);
> > > > +		{
> > > > +			const char *name = va_arg(ap, const char *);
> > > > +			if ((c->proto_version != p9_proto_2000u) &&
> > > > +			    (c->proto_version != p9_proto_2000L))
> > > 
> > > (I don't think 9p2000.L can call TCREATE, but it doesn't really hurt
> > > either)
> > 
> > Yes, Tcreate is only 9p2000 and 9p2000.u. Semantically this particular
> > check here means "if proto == 9p.2000". I can't remember anymore why I
> > came up with this inverted form here. I'll change it to "if
> > (c->proto_version == p9_proto_legacy)".
> 
> Sounds good.
> 
> > > > +	case P9_TRENAMEAT:
> > > if we have trenameat we probably want trename, tunlinkat as well?
> > > What's your criteria for counting individually vs slapping 8k at it?
> > > 
> > > In this particular case, oldname/newname are single component names
> > > within a directory so this is capped at 2*(4+256), that could easily fit
> > > in 4k without bothering.
> > 
> > I have not taken the Linux kernel's current filename limit NAME_MAX
> > (255) as basis, in that case you would be right. Instead I looked up
> > what the maximum filename length among file systems in general was,
> > and saw that ReiserFS supports up to slightly below 4k? So I took 4k
> > as basis for the calculation used here, and the intention was to make
> > this code more future proof. Because revisiting this code later on
> > always takes quite some time and always has this certain potential to
> > miss out details.
> 
> hmm, that's pretty deeply engrained into the VFS but I guess it might
> change eventually, yes.
> 
> I don't mind as long as we're consistent (cf. unlink/mkdir below), in
> practice measuring doesn't cost much.

OK, I also make that more clear from the commit log then that 4k was taken as
basis and why.

> > Independent of the decision; additionally it might make sense to add
> > something like:
> > 
> > #if NAME_MAX > 255
> > # error p9_msg_buf_size() needs adjustments
> > #endif
> 
> That's probably an understatement but I don't mind either way, it
> doesn't hurt.
> 
> > > > +		BUG_ON(strcmp("dsds", fmt));
> > > > +		va_arg(ap, int32_t);
> > > > +		{
> > > > +			const char *oldname = va_arg(ap, const char *);
> > > > +			va_arg(ap, int32_t);
> > > > +			{
> > > > +				const char *newname = va_arg(ap, const char *);
> > > 
> > > (style nitpick) I don't see the point of nesting another level of
> > > indentation here, it feels cleaner to declare oldname/newname at the
> > > start of the block and be done with it.
> > 
> > Because  va_arg(ap, int32_t);  must remain between those two
> > declarations, and I think either the compiler or style check script
> > was barking at me. But I will recheck, if possible I will remove the
> > additional block scope here.
> 
> Yes, I think it'd need to look like this:
> 
> 	case foo:
> 		BUG_ON(...)
> 		va_arg(ap, int32_t);
> 		{
> 			const char *oldname = va_arg(ap, const char *);
> 			const char *newname;
> 			va_arg(ap, int32_t);
> 			newname = va_arg(ap, const_char *);
> 			...
> 		}
> or
> 		{
> 			const char *oldname, *newname;
> 			oldname = va_arg(ap, const char *);
> 			va_arg(ap, int32_t)
> 			newname = va_arg(ap, const char *);
> 			...
> 		}
> 
> I guess the later is slightly easier on the eyes

Ah yes, that's your win there.

> > > > +	/* small message types */
> > > 
> > > ditto: what's your criteria for 4k vs 8k?
> > 
> > As above, 4k being the basis for directory entry names, plus PATH_MAX
> > (4k) as basis for maximum path length.
> > 
> > However looking at it again, if NAME_MAX == 4k was assumed exactly,
> > then Tsymlink would have the potential to exceed 8k, as it has name[s]
> > and symtgt[s] plus the other fields.
> 
> yes.
> 
> > > > +	case P9_TSTAT:
> > > this is just fid[4], so 4k is more than enough
> > 
> > I guess that was a typo and should have been Twstat instead?
> 
> Ah, had missed this because 9p2000.L's version of stat[n] is fixed size.
> Sounds good.
> 
> > > > +	case P9_RSTAT:
> > > also fixed size 4+4+8+8+8+8+8+8+4 -- fits in 4k.
> > 
> > Rstat contains stat[n] which in turn contains variable-length string
> > fields (filename, owner name, group name)
> 
> Right, same mistake.
> 
> > > > +	case P9_TSYMLINK:
> > > that one has symlink target which can be arbitrarily long (filesystem
> > > specific, 4k is the usual limit for linux but some filesystem I don't
> > > know might handle more -- it might be worth going through the trouble of
> > > going through it.
> > 
> > Like mentioned above, if exactly NAME_MAX == 4k was assumed, then
> > Tsymlink may even be >8k.
> 
> And all the other remarks are 'yes if we assume bigger NAME_MAX' -- I'm
> happy either way.
> 
> > > rest all looks ok to me.
> > 
> > Thanks for the review! I know, that's really a dry patch to look
> > at. :)
> 
> Thanks for writing it in the first place ;)
> 
> --
> Dominique




