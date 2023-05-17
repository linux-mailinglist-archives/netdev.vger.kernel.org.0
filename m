Return-Path: <netdev+bounces-3191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB969705F20
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E78A281223
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FE9210D;
	Wed, 17 May 2023 05:14:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770ED64C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:14:31 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 87D8C35A8;
	Tue, 16 May 2023 22:14:28 -0700 (PDT)
Received: from [172.30.38.111] (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 36E23180120DC3;
	Wed, 17 May 2023 13:14:12 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------6RiRB9aWvOzrHmmlk1Za6Ipu"
Message-ID: <bea72de9-5f97-16a9-6703-05789ed53c1d@nfschina.com>
Date: Wed, 17 May 2023 13:14:11 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next] net: bna: bnad: Remove unnecessary (void*)
 conversions
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: rmody@marvell.com, skalluru@marvell.com, GR-Linux-NIC-Dev@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: yunchuan <yunchuan@nfschina.com>
In-Reply-To: <20230516201739.21c37850@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a multi-part message in MIME format.
--------------6RiRB9aWvOzrHmmlk1Za6Ipu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2023/5/17 11:17, Jakub Kicinski 写道:
> On Wed, 17 May 2023 10:27:05 +0800 wuych wrote:
>> Pointer variables of void * type do not require type cast.
> What tool are you using to find these.
> How many of such patches will it take to clean up the entire tree?


I use the scripts I found on the  kernel Newbies to find these.

website: https://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs


--------------6RiRB9aWvOzrHmmlk1Za6Ipu
Content-Type: application/x-perl; name="type-convs.pl"
Content-Disposition: attachment; filename="type-convs.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl
# This scripts goes through the kernel sources and
# prints assignments of (void*) functions that
# get type-changed:
#   type *x = (type*) function().
# The first argument is the kernel source directory, additional 
# arguments override the embedded function name list.


$kernel_dir=shift || die "Need a directory argument (kernel sources),\n" .
"and optionally function names.\n" .
"If none are given, a default list is taken.\n";

# Get source files
@ARGV=split(/\0/, `find "$kernel_dir" -type f -iname "*.c" -print0`);
die "No sources found.\n" unless @ARGV;

# Read whole files, and look for such assignments.
$/=undef;
while (<>)
{
	$changes=0;
#		- struct netdev_private *np = (struct netdev_private *)dev->priv;
#		+ struct netdev_private *np = dev->priv;
#	or just
#	   lp = (struct i596_private *) dev->priv;
	$changes++ while 
		s{ 
			( (?: struct \s+ \w+ \s* \* \s*)? \w+ \s+ = ) \s* 
				\( [\w\s\*]+ \* \s* \) \s* 
				( \w+ \s* -> \s* priv(?:ate)? \s* ; )
		}{$1 $2}xgo;

	if ($changes)
	{
		open(DIFF, qq(| diff -up --label "$ARGV" "$ARGV" --label "$ARGV" -)) 
		|| die "Cannot start diff program: $!\n";
		print DIFF $_;
		close DIFF;
	}
}

--------------6RiRB9aWvOzrHmmlk1Za6Ipu--

