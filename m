Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F16BE62D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 11:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCQKFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 06:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCQKFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 06:05:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E07462DB6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 03:05:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so2920258wmb.3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 03:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679047529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QRx5vZBVNnnmgnoYHZJCYO3J3a53Dt72pC70S/NMKcg=;
        b=sDPNTGgp75Qlgbp2OCh29VCgxqcG0GcrYVIzT7Tglk0Ym/Ci+Ro8F9L1xYmUtvi4yN
         NSrzqb1VDchcJQzen1yAy+pRhP0hy+9ygNNgeoMqe0pRcaiMCNSjMZMbPQbI4m6KLutP
         2+gikH/j5MvDqtVaMVtI3Q1yJvCDRZ+fVNSPBYsBaz+aoYpSF5uDiTciTgf9iMJDm/Fn
         WWXyIHctXAKXolVoCaIQCNXXg5M71Rxv/BwTfOBIZXd4sIH4ncEaw7qd8ZRy3nvo7K7j
         5F0T/pmpMdrv/Issye5ECLTczqZ4U56bwsZlQN0BTHqHvcEbT7SG30bsOenBAZG8Aih8
         ZEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679047529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRx5vZBVNnnmgnoYHZJCYO3J3a53Dt72pC70S/NMKcg=;
        b=oVoj0Oq2ClK6VTF8wFZa5hlXTOn5qUYUkzLFQRP81QkVA691TGAJhsbvAIyUTnGhvU
         zsS7uWBDl9eZfbb40bY2qCqdhOjKtfjj4URdmgqHsxSwsWcmPtDSAat55mSPqM1jqPAk
         mbM9swxUQAG+gobUFshgGNVxZH83NzfsHkM3XMHmxQkdlS7lpq0stzP329sxE+kICOE+
         3++iL0qh4gp+DNlNnMdv1fd39GqyfxaXmNAe8ze4qa510tf2/9Fxv90vNdWk6rTN6P41
         S80/5aolbMdkzC04PAS90mNZXja1Bpr8MwKhUmmxlCu/OIQkFi9NUUGozm7LqQiI7KlZ
         4lLg==
X-Gm-Message-State: AO0yUKXMDOkRcpuzChPkMNj3saojDD5Du7ARKSe/h3q/CQT5h3kE/Uv3
        CCKD6/nJqIC3sr2TDhw9fY10tw==
X-Google-Smtp-Source: AK7set84eFS8B/h6B96cpCMlq0snwHSEcgfwvJFhFOSAznYwDWHXfsTOd3KFCgvjePjpL5YX+G7Tfw==
X-Received: by 2002:a05:600c:3ac3:b0:3ea:ed4d:38f6 with SMTP id d3-20020a05600c3ac300b003eaed4d38f6mr23617667wms.4.1679047528644;
        Fri, 17 Mar 2023 03:05:28 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c8-20020adfe708000000b002cde626cd96sm1555785wrm.65.2023.03.17.03.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:05:28 -0700 (PDT)
Date:   Fri, 17 Mar 2023 11:05:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBQ7ZuJSXRfFOy1b@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
 <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 17, 2023 at 01:52:44AM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Thursday, March 16, 2023 2:45 PM
>>
>
>[...]
>
>>>>>+attribute-sets:
>>>>>+  -
>>>>>+    name: dpll
>>>>>+    enum-name: dplla
>>>>>+    attributes:
>>>>>+      -
>>>>>+        name: device
>>>>>+        type: nest
>>>>>+        value: 1
>>>>>+        multi-attr: true
>>>>>+        nested-attributes: device
>>>>
>>>>What is this "device" and what is it good for? Smells like some leftover
>>>>and with the nested scheme looks quite odd.
>>>>
>>>
>>>No, it is nested attribute type, used when multiple devices are returned
>>>with netlink:
>>>
>>>- dump of device-get command where all devices are returned, each one nested
>>>inside it:
>>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id': 0},
>>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id': 1}]}]
>>
>>Okay, why is it nested here? The is one netlink msg per dpll device
>>instance. Is this the real output of you made that up?
>>
>>Device nest should not be there for DEVICE_GET, does not make sense.
>>
>
>This was returned by CLI parser on ice with cmd:
>$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
>--dump device-get
>
>Please note this relates to 'dump' request , it is rather expected that there
>are multiple dplls returned, thus we need a nest attribute for each one.

No, you definitelly don't need to nest them. Dump format and get format
should be exactly the same. Please remove the nest.

See how that is done in devlink for example: devlink_nl_fill()
This functions fills up one object in the dump. No nesting.
I'm not aware of such nesting approach anywhere in kernel dumps, does
not make sense at all.


>
>>
>>>
>>>- do/dump of pin-get, in case of shared pins, each pin contains number of
>>dpll
>>>handles it connects with:
>>>[{'pin': [{'device': [{'bus-name': 'pci',
>>>                       'dev-name': '0000:21:00.0_0',
>>>                       'id': 0,
>>>                       'pin-prio': 6,
>>>                       'pin-state': {'doc': 'pin connected',
>>>                                     'name': 'connected'}},
>>>                      {'bus-name': 'pci',
>>>                       'dev-name': '0000:21:00.0_1',
>>>                       'id': 1,
>>>                       'pin-prio': 8,
>>>                       'pin-state': {'doc': 'pin connected',
>>>                                     'name': 'connected'}}],
>>
>>Okay, here I understand it contains device specific pin items. Makes
>>sense!
>>
>
>Good.

Make sure you don't nest the pin objects for dump (DPLL_A_PIN). Same
reason as above.
I don't see a need for DPLL_A_PIN attr existence, please remove it.




>
>[...]
>
>>>
>>>>
>>>>
>>>>>+      -
>>>>>+        name: pin-prio
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-state
>>>>>+        type: u8
>>>>>+        enum: pin-state
>>>>>+      -
>>>>>+        name: pin-parent
>>>>>+        type: nest
>>>>>+        multi-attr: true
>>>>>+        nested-attributes: pin
>>>>>+        value: 23
>>>>
>>>>Value 23? What's this?
>>>>You have it specified for some attrs all over the place.
>>>>What is the reason for it?
>>>>
>>>
>>>Actually this particular one is not needed (also value: 12 on pin above),
>>>I will remove those.
>>>But the others you are refering to (the ones in nested attribute list),
>>>are required because of cli.py parser issue, maybe Kuba knows a better way
>>to
>>>prevent the issue?
>>>Basically, without those values, cli.py brakes on parsing responses, after
>>>every "jump" to nested attribute list it is assigning first attribute
>>there
>>>with value=0, thus there is a need to assign a proper value, same as it is
>>on
>>>'main' attribute list.
>>
>>That's weird. Looks like a bug then?
>>
>
>Guess we could call it a bug, I haven't investigated the parser that much,
>AFAIR, other specs are doing the same way.
>
>>
>>>
>>>>
>>>>>+      -
>>>>>+        name: pin-parent-idx
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-rclk-device
>>>>>+        type: string
>>>>>+      -
>>>>>+        name: pin-dpll-caps
>>>>>+        type: u32
>>>>>+  -
>>>>>+    name: device
>>>>>+    subset-of: dpll
>>>>>+    attributes:
>>>>>+      -
>>>>>+        name: id
>>>>>+        type: u32
>>>>>+        value: 2
>>>>>+      -
>>>>>+        name: dev-name
>>>>>+        type: string
>>>>>+      -
>>>>>+        name: bus-name
>>>>>+        type: string
>>>>>+      -
>>>>>+        name: mode
>>>>>+        type: u8
>>>>>+        enum: mode
>>>>>+      -
>>>>>+        name: mode-supported
>>>>>+        type: u8
>>>>>+        enum: mode
>>>>>+        multi-attr: true
>>>>>+      -
>>>>>+        name: source-pin-idx
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: lock-status
>>>>>+        type: u8
>>>>>+        enum: lock-status
>>>>>+      -
>>>>>+        name: temp
>>>>>+        type: s32
>>>>>+      -
>>>>>+        name: clock-id
>>>>>+        type: u64
>>>>>+      -
>>>>>+        name: type
>>>>>+        type: u8
>>>>>+        enum: type
>>>>>+      -
>>>>>+        name: pin
>>>>>+        type: nest
>>>>>+        value: 12
>>>>>+        multi-attr: true
>>>>>+        nested-attributes: pin
>>>>
>>>>This does not belong here.
>>>>
>>>
>>>What do you mean?
>>>With device-get 'do' request the list of pins connected to the dpll is
>>>returned, each pin is nested in this attribute.
>>
>>No, wait a sec. You have 2 object types: device and pin. Each have
>>separate netlink CMDs to get and dump individual objects.
>>Don't mix those together like this. I thought it became clear in the
>>past. :/
>>
>
>For pins we must, as pins without a handle to a dpll are pointless.

I'm not talking about per device specific items for pins (state and
prio). That is something else, it's a pin-device tuple. Completely fine.



>Same as a dpll without pins, right?
>
>'do' of DEVICE_GET could just dump it's own status, without the list of pins,

Yes please.


>but it feels easier for handling it's state on userspace counterpart if that
>command also returns currently registered pins. Don't you think so?

No, definitelly not. Please make the object separation clear. Device and
pins are different objects, they have different commands to work with.
Don't mix them together.


>
>>
>>>This is required by parser to work.
>>>
>>>>
>>>>>+      -
>>>>>+        name: pin-prio
>>>>>+        type: u32
>>>>>+        value: 21
>>>>>+      -
>>>>>+        name: pin-state
>>>>>+        type: u8
>>>>>+        enum: pin-state
>>>>>+      -
>>>>>+        name: pin-dpll-caps
>>>>>+        type: u32
>>>>>+        value: 26
>>>>
>>>>All these 3 do not belong here are well.
>>>>
>>>
>>>Same as above explanation.
>>
>>Same as above reply.
>>
>>
>>>
>>>>
>>>>
>>>>>+  -
>>>>>+    name: pin
>>>>>+    subset-of: dpll
>>>>>+    attributes:
>>>>>+      -
>>>>>+        name: device
>>>>>+        type: nest
>>>>>+        value: 1
>>>>>+        multi-attr: true
>>>>>+        nested-attributes: device
>>>>>+      -
>>>>>+        name: pin-idx
>>>>>+        type: u32
>>>>>+        value: 13
>>>>>+      -
>>>>>+        name: pin-description
>>>>>+        type: string
>>>>>+      -
>>>>>+        name: pin-type
>>>>>+        type: u8
>>>>>+        enum: pin-type
>>>>>+      -
>>>>>+        name: pin-direction
>>>>>+        type: u8
>>>>>+        enum: pin-direction
>>>>>+      -
>>>>>+        name: pin-frequency
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-frequency-supported
>>>>>+        type: u32
>>>>>+        multi-attr: true
>>>>>+      -
>>>>>+        name: pin-any-frequency-min
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-any-frequency-max
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-prio
>>>>>+        type: u32
>>>>>+      -
>>>>>+        name: pin-state
>>>>>+        type: u8
>>>>>+        enum: pin-state
>>>>>+      -
>>>>>+        name: pin-parent
>>>>>+        type: nest
>>>>>+        multi-attr: true
>>>>
>>>>Multiple parents? How is that supposed to work?
>>>>
>>>
>>>As we have agreed, MUXed pins can have multiple parents.
>>>In our case:
>>>/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>>>pin-get --json '{"id": 0, "pin-idx":13}'
>>>{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0',
>>>'id': 0},
>>>                     {'bus-name': 'pci',
>>>                      'dev-name': '0000:21:00.0_1',
>>>                      'id': 1}],
>>>          'pin-description': '0000:21:00.0',
>>>          'pin-direction': {'doc': 'pin used as a source of a signal',
>>>                            'name': 'source'},
>>>          'pin-idx': 13,
>>>          'pin-parent': [{'pin-parent-idx': 2,
>>>                          'pin-state': {'doc': 'pin disconnected',
>>>                                        'name': 'disconnected'}},
>>>                         {'pin-parent-idx': 3,
>>>                          'pin-state': {'doc': 'pin disconnected',
>>>                                        'name': 'disconnected'}}],
>>>          'pin-rclk-device': '0000:21:00.0',
>>>          'pin-type': {'doc': "ethernet port PHY's recovered clock",
>>>                       'name': 'synce-eth-port'}}]}
>>
>>Got it, it is still a bit hard to me to follow this. Could you
>>perhaps extend the Documentation to describe in more details
>>with examples? Would help a lot for slower people like me to understand
>>what's what.
>>
>
>Actually this is already explained in "MUX-type pins" paragraph of
>Documentation/networking/dpll.rst.
>Do we want to duplicate this explanation here?

No, please extend the docs. As I wrote above, could you add some
examples, like the one you pasted above. Examples always help to
undestand things much better.


>
>
>>
>>>
>>>
>>>>
>>>>>+        nested-attributes: pin-parent
>>>>>+        value: 23
>>>>>+      -
>>>>>+        name: pin-rclk-device
>>>>>+        type: string
>>>>>+        value: 25
>>>>>+      -
>>>>>+        name: pin-dpll-caps
>>>>>+        type: u32
>>>>
>>>>Missing "enum: "
>>>>
>>>
>>>It is actually a bitmask, this is why didn't set as enum, with enum type
>>>parser won't parse it.
>>
>>Ah! Got it. Perhaps a docs note with the enum pointer then?
>>
>
>Same as above, explained in Documentation/networking/dpll.rst, do wan't to
>duplicate?

For this, yes. Some small doc note here would be quite convenient.

Also, I almost forgot: Please don't use NLA_U32 for caps flags. Please
use NLA_BITFIELD32 which was introduced for exactly this purpose. Allows
to do nicer validation as well.


>
>>
>>>
>>>>
>>>>>+  -
>>>>>+    name: pin-parent
>>>>>+    subset-of: dpll
>>>>>+    attributes:
>>>>>+      -
>>>>>+        name: pin-state
>>>>>+        type: u8
>>>>>+        value: 22
>>>>>+        enum: pin-state
>>>>>+      -
>>>>>+        name: pin-parent-idx
>>>>>+        type: u32
>>>>>+        value: 24
>>>>>+      -
>>>>>+        name: pin-rclk-device
>>>>>+        type: string
>>>>
>>>>Yeah, as I wrote in the other email, this really smells to
>>>>have like a simple string like this. What is it supposed to be?
>>>>
>>>
>>>Yes, let's discuss there.
>>
>>Yep.
>>
>>>
>>>>
>>>>>+
>>>>>+
>>>>>+operations:
>>>>>+  list:
>>>>>+    -
>>>>>+      name: unspec
>>>>>+      doc: unused
>>>>>+
>>>>>+    -
>>>>>+      name: device-get
>>>>>+      doc: |
>>>>>+        Get list of DPLL devices (dump) or attributes of a single dpll
>>>>device
>>>>>+      attribute-set: dpll
>>>>
>>>>Shouldn't this be "device"?
>>>>
>>>
>>>It would brake the parser, again I hope Jakub Kicinski could take a look
>>>on this.
>>
>>Odd.
>>
>
>Yes, seems a bit odd.
>
>>>
>>>>
>>>>>+      flags: [ admin-perm ]
>>>>>+
>>>>>+      do:
>>>>>+        pre: dpll-pre-doit
>>>>>+        post: dpll-post-doit
>>>>>+        request:
>>>>>+          attributes:
>>>>>+            - id
>>>>>+            - bus-name
>>>>>+            - dev-name
>>>>>+        reply:
>>>>>+          attributes:
>>>>>+            - device
>>>>>+
>>>>>+      dump:
>>>>>+        pre: dpll-pre-dumpit
>>>>>+        post: dpll-post-dumpit
>>>>>+        reply:
>>>>>+          attributes:
>>>>>+            - device
>>>>>+
>>>>>+    -
>>>>>+      name: device-set
>>>>>+      doc: Set attributes for a DPLL device
>>>>>+      attribute-set: dpll
>>>>
>>>>"device" here as well?
>>>>
>>>
>>>Same as above.
>>>
>>>>
>>>>>+      flags: [ admin-perm ]
>>>>>+
>>>>>+      do:
>>>>>+        pre: dpll-pre-doit
>>>>>+        post: dpll-post-doit
>>>>>+        request:
>>>>>+          attributes:
>>>>>+            - id
>>>>>+            - bus-name
>>>>>+            - dev-name
>>>>>+            - mode
>>>>
>>>>Hmm, shouldn't source-pin-index be here as well?
>>>
>>>No, there is no set for this.
>>>For manual mode user selects the pin by setting enabled state on the one
>>>he needs to recover signal from.
>>>
>>>source-pin-index is read only, returns active source.
>>
>>Okay, got it. Then why do we have this assymetric approach? Just have
>>the enabled state to serve the user to see which one is selected, no?
>>This would help to avoid confusion (like mine) and allow not to create
>>inconsistencies (like no pin enabled yet driver to return some source
>>pin index)
>>
>
>This is due to automatic mode were multiple pins are enabled, but actual
>selection is done on hardware level with priorities.

Okay, this is confusing and I believe wrong.
You have dual meaning for pin state attribute with states
STATE_CONNECTED/DISCONNECTED:

1) Manual mode, MUX pins (both share the same model):
   There is only one pin with STATE_CONNECTED. The others are in
   STATE_DISCONNECTED
   User changes a state of a pin to make the selection.

   Example:
     $ dplltool pin dump
       pin 1 state connected
       pin 2 state disconnected
     $ dplltool pin 2 set state connected
     $ dplltool pin dump
       pin 1 state disconnected
       pin 2 state connected

2) Automatic mode:
   The user by setting "state" decides it the pin should be considered
   by the device for auto selection.

   Example:
     $ dplltool pin dump:
       pin 1 state connected prio 10
       pin 2 state connected prio 15
     $ dplltool dpll x get:
       dpll x source-pin-index 1

So in manual mode, STATE_CONNECTED means the dpll is connected to this
source pin. However, in automatic mode it means something else. It means
the user allows this pin to be considered for auto selection. The fact
the pin is selected source is exposed over source-pin-index.

Instead of this, I believe that the semantics of
STATE_CONNECTED/DISCONNECTED should be the same for automatic mode as
well. Unlike the manual mode/mux, where the state is written by user, in
automatic mode the state should be only written by the driver. User
attemts to set the state should fail with graceful explanation (DPLL
netlink/core code should handle that, w/o driver interaction)

Suggested automatic mode example:
     $ dplltool pin dump:
       pin 1 state connected prio 10 connectable true
       pin 2 state disconnected prio 15 connectable true
     $ dplltool pin 1 set connectable false
     $ dplltool pin dump:
       pin 1 state disconnected prio 10 connectable false
       pin 2 state connected prio 15 connectable true
     $ dplltool pin 1 set state connected
       -EOPNOTSUPP

Note there is no "source-pin-index" at all. Replaced by pin state here.
There is a new attribute called "connectable", the user uses this
attribute to tell the device, if this source pin could be considered for
auto selection or not.

Could be called perhaps "selectable", does not matter. The point is, the
meaning of the "state" attribute is consistent for automatic mode,
manual mode and mux pin.

Makes sense?


>
>[...]
>
>>>>>+
>>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE +
>>>>>1]
>>>>>= {
>>>>>+	[DPLL_A_ID] = { .type = NLA_U32, },
>>>>>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>>>>>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>>>>>+	[DPLL_A_MODE] = NLA_POLICY_MAX(NLA_U8, 5),
>>>>
>>>>Hmm, any idea why the generator does not put define name
>>>>here instead of "5"?
>>>>
>>>
>>>Not really, it probably needs a fix for this.
>>
>>Yeah.
>>
>
>Well, once we done with review maybe we could also fix those, or ask
>Jakub if he could help :)
>
>
>[...]
>
>>>>
>>>>>+	DPLL_A_PIN_PRIO,
>>>>>+	DPLL_A_PIN_STATE,
>>>>>+	DPLL_A_PIN_PARENT,
>>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>>
>>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>>>>enum name.
>>>
>>>Sure, fixed.
>>
>>
>>Thanks for all your work on this!
>
>Thanks for a great review! :)

Glad to help.
