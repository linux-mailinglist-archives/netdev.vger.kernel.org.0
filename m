Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC12699BE
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINXgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINXgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 19:36:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE8AD20897;
        Mon, 14 Sep 2020 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600126567;
        bh=naJmvd7PAuPHl4ywAt7FEnW6NxRdPEq1muULAUcqQ0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aY39OMkls2svII1GI5gdVIEkFcI35p8fFdLIDSX8NoAyga5zfY4z05a770hqXrHsx
         yrbjqCCK6+s6Qup0I59Ca9Bxzd9T7buAewiEnwalFZBOmVD//BbrqF7uGHnTyzbGI+
         aKrWv7FYqEuVqMPVcwRkFoyEKzLDk73J3nmEh3VI=
Date:   Mon, 14 Sep 2020 16:36:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 16:15:28 -0700 Jacob Keller wrote:
> On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
> > IOW drop the component parameter from the normal helper, cause almost
> > nobody uses that. The add a more full featured __ version, which would
> > take the arg struct, the struct would include the timeout value.
> >   
> I would point out that the ice driver does use it to help indicate which
> section of the flash is currently being updated.
> 
> i.e.
> 
> $ devlink dev flash pci/0000:af:00.0 file firmware.bin
> Preparing to flash
> [fw.mgmt] Erasing
> [fw.mgmt] Erasing done
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flashing done 100%
> [fw.undi] Erasing
> [fw.undi] Erasing done
> [fw.undi] Flashing 100%
> [fw.undi] Flashing done 100%
> [fw.netlist] Erasing
> [fw.netlist] Erasing done
> [fw.netlist] Flashing 100%
> [fw.netlist] Flashing done 100%
> 
> I'd like to keep that, as it helps tell which component is currently
> being updated. If we drop this, then either I have to manually build
> strings which include the component name, or we lose this information on
> display.

Thanks for pointing that out. My recollection was that ice and netdevsim
were the only two users, so I thought those could use the full __*
helper and pass an arg struct. But no strong feelings.
