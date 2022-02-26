Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9864C5497
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiBZIIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiBZIIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:08:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452133EAAB;
        Sat, 26 Feb 2022 00:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDFC160E9A;
        Sat, 26 Feb 2022 08:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42924C340E8;
        Sat, 26 Feb 2022 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645862866;
        bh=evy4XN0cXQyAddyjb+9P2DGhByVUh1+2+x/nxkz9HVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aPaJX3B0nVG9Plv7XUMl8R0QoyyUx/FeIjg+sCFJrzo13lvj2995wcuhhygQ/nI9I
         X1h48zTRyNbREfOIDKyvxtDaTdlilOuzSzDW30szePFrzdQ6naW5ZTBOr1l5BTWq4Q
         o5eSJodUy+0qe75UTrL7JhLA9T437rbdFnkq3m4s=
Date:   Sat, 26 Feb 2022 09:07:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Message-ID: <YhnfzipoU1NbkjQQ@kroah.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
 <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
 <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 02:11:04PM -0500, Mimi Zohar wrote:
> On Fri, 2022-02-25 at 08:41 +0000, Roberto Sassu wrote:
> > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > Sent: Friday, February 25, 2022 1:22 AM
> > > Hi Roberto,
> > > 
> > > On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > implementation of integrity-focused LSMs based on eBPF.
> > > 
> > > I've previously requested adding eBPF module measurements and signature
> > > verification support in IMA.  There seemed to be some interest, but
> > > nothing has been posted.
> > 
> > Hi Mimi
> > 
> > for my use case, DIGLIM eBPF, IMA integrity verification is
> > needed until the binary carrying the eBPF program is executed
> > as the init process. I've been thinking to use an appended
> > signature to overcome the limitation of lack of xattrs in the
> > initial ram disk.
> 
> I would still like to see xattrs supported in the initial ram disk. 
> Assuming you're still interested in pursuing it, someone would need to
> review and upstream it.  Greg?

Me?  How about the filesystem maintainers and developers?  :)

There's a reason we never added xattrs support to ram disks, but I can't
remember why...

thanks,

gre gk-h
