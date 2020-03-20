Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981B318D282
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgCTPLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbgCTPLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 11:11:07 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35162072D;
        Fri, 20 Mar 2020 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584717066;
        bh=qz6nxjt+oHRdtFK5DtUf8W3pt7MtXBjKeLpdYT+SXj4=;
        h=From:To:Cc:Subject:Date:From;
        b=jMVdDgVTlPr9q4qgOQX+s+/uNPsSTDhfGiESnAjI2AGmzXCyl3PkU1dSvU2b2I1Vu
         CGQA+Ezuq0o70vsmAIKPEauiCmAHHE0cYxQfeWLwYuups0vVmKNTcxChn7S4KXSOvq
         4g6dIhGnq0ArXroR/CxDRUgHb/DLqWbXrZyQEEaQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jFJIe-000ukc-Gx; Fri, 20 Mar 2020 16:11:04 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
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
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 0/2] Don't generate thousands of new warnings when building docs
Date:   Fri, 20 Mar 2020 16:11:01 +0100
Message-Id: <cover.1584716446.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series address a regression caused by a new patch at
docs-next (and at linux-next).

Before this patch, when a cross-reference to a chapter within the
documentation is needed, we had to add a markup like:

	.. _foo:

	foo
	===

This behavor is now different after this patch:

	58ad30cf91f0 ("docs: fix reference to core-api/namespaces.rst")

As a Sphinx extension now creates automatically a reference
like the above, without requiring any extra markup.

That, however, comes with a price: it is not possible anymore to have
two sections with the same name within the entire Kernel docs!

This causes thousands of warnings, as we have sections named
"introduction" on lots of places.

This series solve this regression by doing two changes:

1) The references are now prefixed by the document name. So,
   a file named "bar" would have the "foo" reference as "bar:foo".

2) It will only use the first two levels. The first one is (usually) the
   name of the document, and the second one the chapter name.

This solves almost all problems we have. Still, there are a few places
where we have two chapters at the same document with the
same name. The first patch addresses this problem.

The second patch limits the escope of the autosectionlabel.

Mauro Carvalho Chehab (2):
  docs: prevent warnings due to autosectionlabel
  docs: conf.py: avoid thousands of duplicate label warning on Sphinx

 Documentation/conf.py                                 |  4 ++++
 Documentation/driver-api/80211/mac80211-advanced.rst  |  8 ++++----
 Documentation/driver-api/dmaengine/index.rst          |  4 ++--
 Documentation/filesystems/ecryptfs.rst                | 11 +++++------
 Documentation/kernel-hacking/hacking.rst              |  4 ++--
 Documentation/media/kapi/v4l2-controls.rst            |  8 ++++----
 Documentation/networking/snmp_counter.rst             |  4 ++--
 Documentation/powerpc/ultravisor.rst                  |  4 ++--
 Documentation/security/siphash.rst                    |  8 ++++----
 Documentation/target/tcmu-design.rst                  |  6 +++---
 .../translations/zh_CN/process/5.Posting.rst          |  2 +-
 Documentation/x86/intel-iommu.rst                     |  3 ++-
 12 files changed, 35 insertions(+), 31 deletions(-)

-- 
2.24.1


