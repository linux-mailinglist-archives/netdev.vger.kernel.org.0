Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D2164BF4
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSRdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:33:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:33624 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgBSRdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 12:33:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 09:33:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="229867612"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 19 Feb 2020 09:33:09 -0800
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink .info_get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-7-jacob.e.keller@intel.com>
 <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
Date:   Wed, 19 Feb 2020 09:33:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/2020 6:45 PM, Jakub Kicinski wrote:
> On Fri, 14 Feb 2020 15:22:05 -0800 Jacob Keller wrote:
>> The devlink .info_get callback allows the driver to report detailed
>> version information. The following devlink versions are reported with
>> this initial implementation:
>>
>>  "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
>>  "fw.mgmt.api" -> API version of interface exposed over the AdminQ
>>  "fw.mgmt.bundle" -> Unique identifier for the firmware bundle
>>  "fw.undi.orom" -> Version of the Option ROM containing the UEFI driver
>>  "nvm.psid" -> Version of the format for the NVM parameter set
>>  "nvm.bundle" -> Unique identifier for the combined NVM image
> 
> I spent some time today trying to write up the design choices behind
> the original implementation but I think I can't complete that unless 
> I understand what the PSID thing really is.
> 

Ok.

> So the original design is motivated by two things:
>  - making FW versions understandable / per component (as opposed 
>    to the crowded ethtool string)
>  - making it possible to automate FW management in a fleet of machines
>    across vendors.
> 
> The second one is more important.
> 
> The design was expecting the following:
>  - HW design is uniquely identified by 'fixed' versions;
>  - each HW design requires only one FW build (but FW build can cover
>    multiple versions of HW);
> 
> This is why serial number is not part of the fixed versions, even
> though it is fixed. Serial is different per board, users should be 
> able to map HW design to the FW version they want to run.
> 

Right. Serial is separate from board, while something like the board.id
is an identifier of the *design* of the board, not of an individual one.

> Effectively FW update agent does this:
> 
>   # Get unique HW design identifier
>   $hw_id = devlink-dev-info['fixed']
> 
>   # Find out which FW we want to use for this NIC
>   $want_fw_id = some-db-backed.lookup($hw_id)
> 
>   # Update if necessary  
>   if $want_fw_id != devlink-dev-info['stored']:
>      # maybe download the file
>      devlink-dev-flash()
> 
>   # Reboot if necessary
>   if $want_fw_id != devlink-dev-info['running']
>      reboot()
> 
> 
> dev-info sets can obviously contain multiple values, but field by field
> comparison for simple == and != should work just fine.
> 
> The complications which had arisen so far are two:
>  - even though all components are versioned some customers expressed
>    uneasiness of only identifying the components but not the entire
>    "build". That's why we added the 'fw.bundle'. When multiple
>    components are "bundled" together into a flashable firmware image
>    that bundle itself gets and ID.
>    I'd expect there to be a bundle for each set of components which are
>    distributed as a FW image. IOW bundle ID per type of file that can
>    be downloaded from the vendor support site. For max convenience I'd
>    think there should be one file that contains all components so
>    customers don't have to juggle files. That means overall fw.bundle
>    that covers all.
>    Note: that fw.bundle is only meaningful if _all_ components are
>    unchanged from flash image, so the FW must do a self-check to
>    validate any component covered by a bundle id is unchanged.
> 

Right that makes sense.

>  - the PSID stuff was added, which IIUC is either (a) an identifier 
>    for configuration parameters which are not visible via normal Linux
>    tools, or (b) a way for an OEM to label a product.
>    This changes where this thing should reside because we don't expect
>    OEM to relabel the product/SKU (or do we?) and hence it's a fixed
>    version.
>    If it's an identifier for random parameters of the board (serdes
>    params, temperature info, IDK) which is expected to maybe be updated
>    or tuned it should be in running/stored.
> 

Hmm. In my case nvm.psid is basically describing the format of the NVM
parameter set, but I don't think it actually covers the contents. This
version can update if you update to a newer image.

I probably need to re-word the versions to be "fw.bundle" and "fw.psid",
rather than using "nvm", given how you're describing the fields above.

>    So any further info on what's an EETRACK in your case?
> 

EETRACK is basically the name we used for "bundle", as it is a unique
identifier generated when new images are prepared.

I think this should probably just become "fw.bundle".

What I have now as "fw.mgmt.bundle" is a little different. It's
basically a unique identifier obtained from the build system of the
management firmware that can be used to identify exactly what got built
for that firmware. (i.e. it would change even if the developers failed
to update their version number).

>    For MLX there's bunch of documents which tell us how we can create 
>    an ini file with parameters, but no info on what those parameters
>    actually are. 
> 
>    Jiri would you be able to help? Please chime in..
> 
> 
> Sorry for the painful review process, it's quite hard to review what
> people are doing without knowing the back end. Hopefully above gives
> you an idea of the intentions when this code was added :)
> 

I understand the difficulty.

> I see that the next patch adds a 'fixed' version, so if that's
> sufficient to identify your board there isn't any blocker here.

Yes, the board.id is the unique identifier of the physical board design.
It's what we've called the Product Board Assembly identifier.

> 
> What I'd still like to consider is:
>  - if fw.mgmt.bundle needs to be a bundle if it doesn't bundle multiple
>    things? If it's hard to inject the build ID into the fw.mgmt version
>    that's fine.

I mostly didn't like having it as part of the same version because it is
somewhat distinct. I don't think it's a "bundle" in the sense of what
you're describing.

It is basically just an identifier from the build system of that
component and will be changed even if the developer did not update the
firmware version. It's useful primarily to identify precisely where that
build of the firmware binary came from. (Hence why I originally used
".build").

>  - fw.undi.orom - do we need to say orom? Is there anything else than
>    orom for UNDI in the flash?

Hmm.. I'll double check this. I wasn't entirely sure if we had other
components which is why I went that route. I think you're right though
and this can just be "fw.undi".

>  - nvm.psid may perhaps be better as nvm.psid.api? Following your
>    fw.mgmt.api?

Hmm. Yea this isn't really a parameter set id, but more of describing
the format. I am not sure I fully understand it myself yet.

>  - nvm.bundle - eetrack sounds mode like a stream, so perhaps this is
>    the PSID?
> 

So, I think this should probably become "fw.bundle", and I can drop the
nvm bits altogether. The EETRACK id is a unique identifier we create
when new images are created. If you have the eetrack you can look up
data on the source binary that the NVM image came from.

It wouldn't cover the parameters that can be changed, so I don't think
it's a psid.


Given this discussion, here is what I have so far:

"fw.bundle" -> What was "nvm.bundle", the identifier for the combined fw
image. This would be our EETRACK id.
"fw.mgmt" -> The management firmware 3 digit version
"fw.mgmt.api" -> The version of API exposed by this firmware
"fw.mgmt.build" -> The build identifier. I really do think this should
be ".build" rather than .bundle, as it's definitely not a bundle in the
same sense. I *could* simply make "fw.mgmt" be "maj.min.patch build" but
I think it makes sense as its own field.

"fw.undi" -> Version of the Option ROM containing the UEFI driver

"fw.psid.api" -> what was the "nvm.psid". This I think needs a bit more
work to define. It makes sense to me as some sort of "api" as (if I
understand it correctly) it is the format for the parameters, but does
not itself define the parameter contents.

The original reason for using "fw" and "nvm" was because we (internally)
use fw to mean the management firmware.. where as these APIs really
combine the blocks and use "fw.mgmt" for the management firmware. Thus I
think it makes sense to move from

I also have a couple other oddities that need to be sorted out. We want
to display the DDP version (piece of "firmware" that is loaded during
driver load, and is not permanent to the NVM). In some sense this is our
"fw.app", but because it's loaded by driver at load and not as
permanently stored in the NVM... I'm not really sure that makes sense to
put this as the "fw.app", since it is not updated or really touched by
the firmware flash update.

Finally we also have a component we call the "netlist", which I'm still
not fully up to speed on exactly what it represents, but it has multiple
pieces of data including a 2-digit Major.Minor version of the base, a
type field indicating the format, and a 2-digit revision field that is
incremented on internal and external changes to the contents. Finally
there is a hash that I think might *actually* be something like a psid
or a bundle to uniquely represent this component. I haven't included
this component yet because I'm still trying to grasp exactly what it
represents and how best to describe each piece.

Thanks for your review,
Jake

>> With this, devlink can now report at least the same information as
>> reported by the older ethtool interface. Each section of the
>> "firmware-version" is also reported independently so that it is easier
>> to understand the meaning.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
