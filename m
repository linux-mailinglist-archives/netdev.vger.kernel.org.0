Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD2D164F54
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBST6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgBST6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 14:58:01 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6DA207FD;
        Wed, 19 Feb 2020 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582142280;
        bh=MJ9E0zSMIigqXY6N5GxtDznbfVOPIdTFFrGz7mtk+Zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2YlTWsYEBwdiK1lbYBN9BYoFMjflRLBq2JaILvtPzNZpmyOVuHHX6bQBDBJUgXXBm
         MWrP3lH+K+s92nqf9SFybNq1xDSripw/T8YUtsaQZdjlSij/yug5JpN7dKs+rRq7+x
         QTnHhg2HEZtRevBPihVTWcig01oCVkjKsxAvJa0M=
Date:   Wed, 19 Feb 2020 11:57:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink
 .info_get
Message-ID: <20200219115757.5af395c5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
        <20200214232223.3442651-7-jacob.e.keller@intel.com>
        <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
        <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 09:33:09 -0800 Jacob Keller wrote:
> >  - the PSID stuff was added, which IIUC is either (a) an identifier=20
> >    for configuration parameters which are not visible via normal Linux
> >    tools, or (b) a way for an OEM to label a product.
> >    This changes where this thing should reside because we don't expect
> >    OEM to relabel the product/SKU (or do we?) and hence it's a fixed
> >    version.
> >    If it's an identifier for random parameters of the board (serdes
> >    params, temperature info, IDK) which is expected to maybe be updated
> >    or tuned it should be in running/stored.
> >  =20
>=20
> Hmm. In my case nvm.psid is basically describing the format of the NVM
> parameter set, but I don't think it actually covers the contents. This
> version can update if you update to a newer image.
>=20
> I probably need to re-word the versions to be "fw.bundle" and "fw.psid",
> rather than using "nvm", given how you're describing the fields above.
>=20
> >    So any further info on what's an EETRACK in your case?
> >  =20
>=20
> EETRACK is basically the name we used for "bundle", as it is a unique
> identifier generated when new images are prepared.
>=20
> I think this should probably just become "fw.bundle".

Okay, cool!

> What I have now as "fw.mgmt.bundle" is a little different. It's
> basically a unique identifier obtained from the build system of the
> management firmware that can be used to identify exactly what got built
> for that firmware. (i.e. it would change even if the developers failed
> to update their version number).
>=20
> >    For MLX there's bunch of documents which tell us how we can create=20
> >    an ini file with parameters, but no info on what those parameters
> >    actually are.=20
> >=20
> >    Jiri would you be able to help? Please chime in..
> >=20
> >=20
> > Sorry for the painful review process, it's quite hard to review what
> > people are doing without knowing the back end. Hopefully above gives
> > you an idea of the intentions when this code was added :)
> >  =20
>=20
> I understand the difficulty.
>=20
> > I see that the next patch adds a 'fixed' version, so if that's
> > sufficient to identify your board there isn't any blocker here. =20
>=20
> Yes, the board.id is the unique identifier of the physical board design.
> It's what we've called the Product Board Assembly identifier.
>=20
> >=20
> > What I'd still like to consider is:
> >  - if fw.mgmt.bundle needs to be a bundle if it doesn't bundle multiple
> >    things? If it's hard to inject the build ID into the fw.mgmt version
> >    that's fine. =20
>=20
> I mostly didn't like having it as part of the same version because it is
> somewhat distinct. I don't think it's a "bundle" in the sense of what
> you're describing.
>=20
> It is basically just an identifier from the build system of that
> component and will be changed even if the developer did not update the
> firmware version. It's useful primarily to identify precisely where that
> build of the firmware binary came from. (Hence why I originally used
> ".build").

Okay.

> >  - fw.undi.orom - do we need to say orom? Is there anything else than
> >    orom for UNDI in the flash? =20
>=20
> Hmm.. I'll double check this. I wasn't entirely sure if we had other
> components which is why I went that route. I think you're right though
> and this can just be "fw.undi".
>=20
> >  - nvm.psid may perhaps be better as nvm.psid.api? Following your
> >    fw.mgmt.api? =20
>=20
> Hmm. Yea this isn't really a parameter set id, but more of describing
> the format. I am not sure I fully understand it myself yet.
>=20
> >  - nvm.bundle - eetrack sounds mode like a stream, so perhaps this is
> >    the PSID?
> >  =20
>=20
> So, I think this should probably become "fw.bundle", and I can drop the
> nvm bits altogether. The EETRACK id is a unique identifier we create
> when new images are created. If you have the eetrack you can look up
> data on the source binary that the NVM image came from.
>=20
> It wouldn't cover the parameters that can be changed, so I don't think
> it's a psid.
>=20
>=20
> Given this discussion, here is what I have so far:
>=20
> "fw.bundle" -> What was "nvm.bundle", the identifier for the combined fw
> image. This would be our EETRACK id.

=F0=9F=91=8D

> "fw.mgmt" -> The management firmware 3 digit version

=F0=9F=91=8D

> "fw.mgmt.api" -> The version of API exposed by this firmware

=F0=9F=91=8D

> "fw.mgmt.build" -> The build identifier. I really do think this should
> be ".build" rather than .bundle, as it's definitely not a bundle in the
> same sense. I *could* simply make "fw.mgmt" be "maj.min.patch build" but
> I think it makes sense as its own field.

okay

> "fw.undi" -> Version of the Option ROM containing the UEFI driver

=F0=9F=91=8D

> "fw.psid.api" -> what was the "nvm.psid". This I think needs a bit more
> work to define. It makes sense to me as some sort of "api" as (if I
> understand it correctly) it is the format for the parameters, but does
> not itself define the parameter contents.

Sounds good. So the contents of parameters would be covered by the
fw.bundle now and not have a separate version?

> The original reason for using "fw" and "nvm" was because we (internally)
> use fw to mean the management firmware.. where as these APIs really
> combine the blocks and use "fw.mgmt" for the management firmware. Thus I
> think it makes sense to move from
>=20
> I also have a couple other oddities that need to be sorted out. We want
> to display the DDP version (piece of "firmware" that is loaded during
> driver load, and is not permanent to the NVM). In some sense this is our
> "fw.app", but because it's loaded by driver at load and not as
> permanently stored in the NVM... I'm not really sure that makes sense to
> put this as the "fw.app", since it is not updated or really touched by
> the firmware flash update.

Interesting, can DDP be persisted to the flash, though? Is there some
default DDP, or is it _never_ in the flash?=20

Does it not have some fun implications for firmware signing to have
part of the config/ucode loaded from the host?

IIRC you could also load multiple of those DDP packages? Perhaps they
could get names like fw.app0, fw.app1, etc? Also if DDP controls a
particular part of the datapath (parser?) feel free to come up with a
more targeted name, up to you.

> Finally we also have a component we call the "netlist", which I'm still
> not fully up to speed on exactly what it represents, but it has multiple
> pieces of data including a 2-digit Major.Minor version of the base, a
> type field indicating the format, and a 2-digit revision field that is
> incremented on internal and external changes to the contents. Finally
> there is a hash that I think might *actually* be something like a psid
> or a bundle to uniquely represent this component. I haven't included
> this component yet because I'm still trying to grasp exactly what it
> represents and how best to describe each piece.

Hmm. netlist is a Si term, perhaps it's chip init data? nfp had
something called chip.init which I think loaded all the very low=20
level Si configs.

My current guess is that psid is more of the serdes and maybe clock
data.=20

Thinking about it now, it seems these versions mirror the company
structure. chip.init comes from the Si team. psid comes from the=20
board design guys. fw.mgmt comes from the BSP/FW team.

None of them are really fixed but the frequency of changes increases
from chip.init changing very rarely to mgmt fw having a regular release
cadence.
