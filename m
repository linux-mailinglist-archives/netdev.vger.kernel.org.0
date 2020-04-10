Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF471A42B9
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDJG4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:56:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:51304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgDJG4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 02:56:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1AE97AE6F;
        Fri, 10 Apr 2020 06:56:15 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 16114E0FAD; Fri, 10 Apr 2020 08:56:12 +0200 (CEST)
Date:   Fri, 10 Apr 2020 08:56:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Konstantin Kharlamov <hi-angel@yandex.ru>, linville@tuxdriver.com
Subject: Re: (repost for 2020y) inconsistency of ethtool feature names for
 get vs. set
Message-ID: <20200410065612.GO3141@unicorn.suse.cz>
References: <36ca2996-ea04-f050-5f88-7edef5a88f26@yandex.ru>
 <20200409194014.GN3141@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409194014.GN3141@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 09:40:14PM +0200, Michal Kubecek wrote:
> On Wed, Apr 08, 2020 at 04:07:39PM +0300, Konstantin Kharlamov wrote:
> > I noticed some inconsistency of feature names with the ethtool getting/setting of features mechanics -- the name of the feature you need to set (through -K) isn't what displayed by the get (-k) directive, here's an example:
> > 
> > $ ethtool -k eth1  | grep generic-receive-offload
> > generic-receive-offload: on
> > 
> > $ ethtool -K eth1  generic-receive-offload off
> > ethtool: bad command line argument(s)
> > For more information run ethtool -h
> > 
> > --> looking in the sources and realizing I need to use "rx-gro"
> > 
> > $ ethtool -K eth1  rx-gro on
> > 
> > $ethtool -k eth1  | grep generic-receive-offload
> > generic-receive-offload: on
> > 
> > same problem for rx checksum which is displayed as "rx-checksumming" by the get (-k)
> > but need to be "rx-checksum" for the set (-K) directive.
> 
> But independent of that, the ioctl code path should also accept actual
> feature names provided by kernel. I'll try to find where the problem is
> and fix it.

After reading the code, I have to correct this: the problem is the
opposite: kernel feature name is "rx-gro" and that does work. However,
this feature (NETIF_F_GRO) belongs under one of the legacy "flags" and
as it's the only one for that flag, ethtool does show flag name instead
of actual feature name (for backward compatibility).

The real problem is that each legacy flag has two names: short and long
(in this case, short is "gro" and long "generic-receive-offload"). And
while "ethtool -k" shows long flag names, "ethtool -K" only accepts
short ones (so that "ethtool -K eth1 gro off" would work).

I still agree that "ethtool -K" not accepting the names tha "ethtool -k"
is unfortunate and it should be fixed. A quick fix below seems to do the
trick but I'll have to run few more tests before submitting it.

A loosely related question is if NETIF_F_GRO_HW ("rx-gro-hw") and
NETIF_F_GRO_FRAGLIST_BIT ("rx-gro-list") shouldn't belong to this legacy
flag (gro / generic-receive-offload) as well. But that would require
also changes on kernel side and it's questionable if we really want to
further improve the concept of legacy flags when it would be cleaner to
get rid of them (which we cannot as it would break the backward
compatibility).

Michal Kubecek


diff --git a/ethtool.c b/ethtool.c
index 1b4e08b6e60f..27411ae776f4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2297,24 +2297,31 @@ static int do_sfeatures(struct cmd_context *ctx)
 	/* Generate cmdline_info for legacy flags and kernel-named
 	 * features, and parse our arguments.
 	 */
-	cmdline_features = calloc(ARRAY_SIZE(off_flag_def) + defs->n_features,
+	cmdline_features = calloc(2 * ARRAY_SIZE(off_flag_def) +
+				  defs->n_features,
 				  sizeof(cmdline_features[0]));
 	if (!cmdline_features) {
 		perror("Cannot parse arguments");
 		rc = 1;
 		goto err;
 	}
-	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++)
+	j = 0;
+	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
 		flag_to_cmdline_info(off_flag_def[i].short_name,
 				     off_flag_def[i].value,
 				     &off_flags_wanted, &off_flags_mask,
-				     &cmdline_features[i]);
+				     &cmdline_features[j++]);
+		flag_to_cmdline_info(off_flag_def[i].long_name,
+				     off_flag_def[i].value,
+				     &off_flags_wanted, &off_flags_mask,
+				     &cmdline_features[j++]);
+	}
 	for (i = 0; i < defs->n_features; i++)
 		flag_to_cmdline_info(
 			defs->def[i].name, FEATURE_FIELD_FLAG(i),
 			&FEATURE_WORD(efeatures->features, i, requested),
 			&FEATURE_WORD(efeatures->features, i, valid),
-			&cmdline_features[ARRAY_SIZE(off_flag_def) + i]);
+			&cmdline_features[j++]);
 	parse_generic_cmdline(ctx, &any_changed, cmdline_features,
 			      ARRAY_SIZE(off_flag_def) + defs->n_features);
 	free(cmdline_features);
