Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49271A055E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGDq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:46:28 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 23:46:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48xCxg52gKz9sR4;
        Tue,  7 Apr 2020 13:46:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1586231183;
        bh=l7KUz8zonmbflimP1h+qknSpc6ld96yDXbEMfnRnCqQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=CueAiY1LX33npSQ9uQbMc52KhJLtkPPnFAs89+F9WT7du9ALrPlU6IMuYH+rvZsjm
         yGxU1Rjz3dyQjphXVFv7lslvM49Co2tfHU1JaSCi71deG6dVvqN9VLJpRprKObQuGd
         ZR7AIK5m1ztVgCajEG0rsVMDqQBiZ6yiQdSlg611TgUDkfeHHBrQma8qKKFgmZ3e4i
         WEHa6vB01klqAFAq+ZoWhnuDBmKvCKFxbgUqcQ3EWGAP73MW0zCbqls4fU2WbTqdjV
         uxfwPc8V71pAFebW85SCuu/Divkkzn/OB3q1E/9I+E5nCfeajK2d3qB/6n35cTHADB
         MWg/IHw5lvIZA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        dmaengine@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Harry Wei <harryxiyou@gmail.com>, x86@kernel.org,
        ecryptfs@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        target-devel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Tyler Hicks <code@tyhicks.com>, Vinod Koul <vkoul@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] Don't generate thousands of new warnings when building docs
In-Reply-To: <cover.1584716446.git.mchehab+huawei@kernel.org>
References: <cover.1584716446.git.mchehab+huawei@kernel.org>
Date:   Tue, 07 Apr 2020 13:46:23 +1000
Message-ID: <87lfn8klf4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:
> This small series address a regression caused by a new patch at
> docs-next (and at linux-next).
>
> Before this patch, when a cross-reference to a chapter within the
> documentation is needed, we had to add a markup like:
>
> 	.. _foo:
>
> 	foo
> 	===
>
> This behavor is now different after this patch:
>
> 	58ad30cf91f0 ("docs: fix reference to core-api/namespaces.rst")
>
> As a Sphinx extension now creates automatically a reference
> like the above, without requiring any extra markup.
>
> That, however, comes with a price: it is not possible anymore to have
> two sections with the same name within the entire Kernel docs!
>
> This causes thousands of warnings, as we have sections named
> "introduction" on lots of places.
>
> This series solve this regression by doing two changes:
>
> 1) The references are now prefixed by the document name. So,
>    a file named "bar" would have the "foo" reference as "bar:foo".
>
> 2) It will only use the first two levels. The first one is (usually) the
>    name of the document, and the second one the chapter name.
>
> This solves almost all problems we have. Still, there are a few places
> where we have two chapters at the same document with the
> same name. The first patch addresses this problem.

I'm still seeing a lot of warnings. Am I doing something wrong?

cheers

/linux/Documentation/powerpc/cxl.rst:406: WARNING: duplicate label powerpc/cxl:open, other instance in /linux/Documentation/powerpc/cxl.rst
/linux/Documentation/powerpc/cxl.rst:412: WARNING: duplicate label powerpc/cxl:ioctl, other instance in /linux/Documentation/powerpc/cxl.rst
/linux/Documentation/powerpc/syscall64-abi.rst:86: WARNING: duplicate label powerpc/syscall64-abi:parameters and return value, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
/linux/Documentation/powerpc/syscall64-abi.rst:90: WARNING: duplicate label powerpc/syscall64-abi:stack, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
/linux/Documentation/powerpc/syscall64-abi.rst:94: WARNING: duplicate label powerpc/syscall64-abi:register preservation rules, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
/linux/Documentation/powerpc/syscall64-abi.rst:103: WARNING: duplicate label powerpc/syscall64-abi:invocation, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
/linux/Documentation/powerpc/syscall64-abi.rst:108: WARNING: duplicate label powerpc/syscall64-abi:transactional memory, other instance in /linux/Documentation/powerpc/syscall64-abi.rst
/linux/Documentation/powerpc/ultravisor.rst:339: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:351: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:365: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:387: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:406: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:416: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:429: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:438: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:452: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:462: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:477: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:484: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:514: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:521: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:527: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:545: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:561: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:573: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:588: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:594: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:613: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:622: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:633: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:639: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:650: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:658: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:669: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:674: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:688: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:697: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:708: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:721: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:737: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:746: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:757: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:771: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:782: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:789: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:798: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:808: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:819: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:828: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:842: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:849: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:886: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:893: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:900: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:909: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:921: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:928: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:938: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:944: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:957: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:964: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:980: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1002: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1017: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1027: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1037: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1053: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1076: WARNING: duplicate label powerpc/ultravisor:syntax, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1086: WARNING: duplicate label powerpc/ultravisor:return values, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1096: WARNING: duplicate label powerpc/ultravisor:description, other instance in /linux/Documentation/powerpc/ultravisor.rst
/linux/Documentation/powerpc/ultravisor.rst:1105: WARNING: duplicate label powerpc/ultravisor:use cases, other instance in /linux/Documentation/powerpc/ultravisor.rst
