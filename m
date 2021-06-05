Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A839C967
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 17:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFEPN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 11:13:56 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:37381 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEPNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 11:13:51 -0400
Received: (Authenticated sender: n@nfraprado.net)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 8D0E020002;
        Sat,  5 Jun 2021 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nfraprado.net;
        s=gm1; t=1622905920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vv4/s0oEatJqm6xOhfhv4SCtKvstG4qCMEYIIpldPy0=;
        b=c3g7o4uEF0JTLo7vMH1ksgmeTVLRz9pP7cqUyB/h+W5DpIymRZemkGu49jcerS4uE/XJQf
        trJLU85vbJBVfZWGFuOsMTCnYVhfSXPxbndF40vAAuKJ0CB9s0KsBjrJ/9zkVZxSK1kZX7
        WPbrr1BsDbMi3udCw9RD6VTWhB3rbd/s8FPEH1mqg/QoOWJo+2T2Gjzqe5dJfYUoJ5uWJi
        mYxE058i/H4Cq0cW3G8Q81eikJU5bVOUF0NbPJeQ/P3UbZMAhOkhJpLRUvntlO2RvnJ5ez
        x1AXAnbGKQtYTh67G2z/msrTC09lBJ7xVdF4ukLxuwInJgcg+Ro9QEyCJg7rbQ==
Date:   Sat, 5 Jun 2021 12:11:09 -0300
From:   =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4=?= Prado <n@nfraprado.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        coresight@lists.linaro.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/34] docs: avoid using ReST :doc:`foo` tag
Message-ID: <20210605151109.axm3wzbcstsyxczp@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1622898327.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab wrote:
> As discussed at:
> 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> 
> It is better to avoid using :doc:`foo` to refer to Documentation/foo.rst, as the
> automarkup.py extension should handle it automatically, on most cases.
> 
> There are a couple of exceptions to this rule:
> 
> 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> 
> It should also be noticed that automarkup.py has currently an issue:
> if one use a markup like:
> 
> 	Documentation/dev-tools/kunit/api/test.rst
> 	  - documents all of the standard testing API excluding mocking
> 	    or mocking related features.
> 
> or, even:
> 
> 	Documentation/dev-tools/kunit/api/test.rst
> 	    documents all of the standard testing API excluding mocking
> 	    or mocking related features.
> 	
> The automarkup.py will simply ignore it. Not sure why. This patch series
> avoid the above patterns (which is present only on 4 files), but it would be
> nice to have a followup patch fixing the issue at automarkup.py.

What I think is happening here is that we're using rST's syntax for definition
lists [1]. automarkup.py ignores literal nodes, and perhaps a definition is
considered a literal by Sphinx. Adding a blank line after the Documentation/...
or removing the additional indentation makes it work, like you did in your
2nd and 3rd patch, since then it's not a definition anymore, although then the
visual output is different as well.

I'm not sure this is something we need to fix. Does it make sense to use
definition lists for links like that? If it does, I guess one option would be to
whitelist definition lists so they aren't ignored by automarkup, but I feel
this could get ugly really quickly.

FWIW note that it's also possible to use relative paths to docs with automarkup.

Thanks,
Nícolas

[1] https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#definition-lists

> 
> On this series:
> 
> Patch 1 manually adjust the references inside driver-api/pm/devices.rst,
> as there it uses :file:`foo` to refer to some Documentation/ files;
> 
> Patch 2 converts a table at Documentation/dev-tools/kunit/api/index.rst
> into a list, carefully avoiding the 
> 
> Patch 3 converts the cross-references at the media documentation, also
> avoiding the automarkup.py bug;
> 
> Patches 4-34 convert the other occurrences via a replace script. They were
> manually edited, in order to honour 80-columns where possible.
> 
> I did a diff between the Sphinx 2.4.4 output before and after this patch
> series in order to double-check that all converted Documentation/ 
> references will produce <a href=<foo>.rst>foo title</a> tags.
> 
> Mauro Carvalho Chehab (34):
>   docs: devices.rst: better reference documentation docs
>   docs: dev-tools: kunit: don't use a table for docs name
>   media: docs: */media/index.rst: don't use ReST doc:`foo`
>   media: userspace-api: avoid using ReST :doc:`foo` markup
>   media: driver-api: drivers: avoid using ReST :doc:`foo` markup
>   media: admin-guide: avoid using ReST :doc:`foo` markup
>   docs: admin-guide: pm: avoid using ReSt :doc:`foo` markup
>   docs: admin-guide: hw-vuln: avoid using ReST :doc:`foo` markup
>   docs: admin-guide: sysctl: avoid using ReST :doc:`foo` markup
>   docs: block: biodoc.rst: avoid using ReSt :doc:`foo` markup
>   docs: bpf: bpf_lsm.rst: avoid using ReSt :doc:`foo` markup
>   docs: core-api: avoid using ReSt :doc:`foo` markup
>   docs: dev-tools: testing-overview.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: dev-tools: kunit: avoid using ReST :doc:`foo` markup
>   docs: devicetree: bindings: submitting-patches.rst: avoid using ReSt
>     :doc:`foo` markup
>   docs: doc-guide: avoid using ReSt :doc:`foo` markup
>   docs: driver-api: avoid using ReSt :doc:`foo` markup
>   docs: driver-api: gpio: using-gpio.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: driver-api: surface_aggregator: avoid using ReSt :doc:`foo`
>     markup
>   docs: driver-api: usb: avoid using ReSt :doc:`foo` markup
>   docs: firmware-guide: acpi: avoid using ReSt :doc:`foo` markup
>   docs: hwmon: adm1177.rst: avoid using ReSt :doc:`foo` markup
>   docs: i2c: avoid using ReSt :doc:`foo` markup
>   docs: kernel-hacking: hacking.rst: avoid using ReSt :doc:`foo` markup
>   docs: networking: devlink: avoid using ReSt :doc:`foo` markup
>   docs: PCI: endpoint: pci-endpoint-cfs.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: PCI: pci.rst: avoid using ReSt :doc:`foo` markup
>   docs: process: submitting-patches.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: security: landlock.rst: avoid using ReSt :doc:`foo` markup
>   docs: trace: coresight: coresight.rst: avoid using ReSt :doc:`foo`
>     markup
>   docs: trace: ftrace.rst: avoid using ReSt :doc:`foo` markup
>   docs: userspace-api: landlock.rst: avoid using ReSt :doc:`foo` markup
>   docs: virt: kvm: s390-pv-boot.rst: avoid using ReSt :doc:`foo` markup
>   docs: x86: avoid using ReSt :doc:`foo` markup
> 
>  .../PCI/endpoint/pci-endpoint-cfs.rst         |  2 +-
>  Documentation/PCI/pci.rst                     |  6 +--
>  .../special-register-buffer-data-sampling.rst |  3 +-
>  Documentation/admin-guide/media/bt8xx.rst     | 15 ++++----
>  Documentation/admin-guide/media/bttv.rst      | 21 ++++++-----
>  Documentation/admin-guide/media/index.rst     | 12 +++---
>  Documentation/admin-guide/media/saa7134.rst   |  3 +-
>  Documentation/admin-guide/pm/intel_idle.rst   | 16 +++++---
>  Documentation/admin-guide/pm/intel_pstate.rst |  9 +++--
>  Documentation/admin-guide/sysctl/abi.rst      |  2 +-
>  Documentation/admin-guide/sysctl/kernel.rst   | 37 ++++++++++---------
>  Documentation/block/biodoc.rst                |  2 +-
>  Documentation/bpf/bpf_lsm.rst                 | 13 ++++---
>  .../core-api/bus-virt-phys-mapping.rst        |  2 +-
>  Documentation/core-api/dma-api.rst            |  5 ++-
>  Documentation/core-api/dma-isa-lpc.rst        |  2 +-
>  Documentation/core-api/index.rst              |  4 +-
>  Documentation/dev-tools/kunit/api/index.rst   |  8 ++--
>  Documentation/dev-tools/kunit/faq.rst         |  2 +-
>  Documentation/dev-tools/kunit/index.rst       | 14 +++----
>  Documentation/dev-tools/kunit/start.rst       |  6 +--
>  Documentation/dev-tools/kunit/tips.rst        |  5 ++-
>  Documentation/dev-tools/kunit/usage.rst       |  8 ++--
>  Documentation/dev-tools/testing-overview.rst  | 16 ++++----
>  .../bindings/submitting-patches.rst           | 11 +++---
>  Documentation/doc-guide/contributing.rst      |  8 ++--
>  Documentation/driver-api/gpio/using-gpio.rst  |  4 +-
>  Documentation/driver-api/ioctl.rst            |  2 +-
>  .../driver-api/media/drivers/bttv-devel.rst   |  2 +-
>  Documentation/driver-api/media/index.rst      | 10 +++--
>  Documentation/driver-api/pm/devices.rst       |  8 ++--
>  .../surface_aggregator/clients/index.rst      |  3 +-
>  .../surface_aggregator/internal.rst           | 15 ++++----
>  .../surface_aggregator/overview.rst           |  6 ++-
>  Documentation/driver-api/usb/dma.rst          |  6 +--
>  .../acpi/dsd/data-node-references.rst         |  3 +-
>  .../firmware-guide/acpi/dsd/graph.rst         |  2 +-
>  .../firmware-guide/acpi/enumeration.rst       |  7 ++--
>  Documentation/hwmon/adm1177.rst               |  3 +-
>  Documentation/i2c/instantiating-devices.rst   |  2 +-
>  Documentation/i2c/old-module-parameters.rst   |  3 +-
>  Documentation/i2c/smbus-protocol.rst          |  4 +-
>  Documentation/kernel-hacking/hacking.rst      |  4 +-
>  .../networking/devlink/devlink-region.rst     |  2 +-
>  .../networking/devlink/devlink-trap.rst       |  4 +-
>  Documentation/process/submitting-patches.rst  | 32 ++++++++--------
>  Documentation/security/landlock.rst           |  3 +-
>  Documentation/trace/coresight/coresight.rst   |  8 ++--
>  Documentation/trace/ftrace.rst                |  2 +-
>  Documentation/userspace-api/landlock.rst      | 11 +++---
>  .../userspace-api/media/glossary.rst          |  2 +-
>  Documentation/userspace-api/media/index.rst   | 12 +++---
>  Documentation/virt/kvm/s390-pv-boot.rst       |  2 +-
>  Documentation/x86/boot.rst                    |  4 +-
>  Documentation/x86/mtrr.rst                    |  2 +-
>  55 files changed, 217 insertions(+), 183 deletions(-)
> 
> -- 
> 2.31.1
> 
> 
