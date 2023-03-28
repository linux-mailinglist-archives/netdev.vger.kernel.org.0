Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906C76CC64A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbjC1P3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjC1P2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:28:36 -0400
Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [IPv6:2001:41d0:1004:224b::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74459F77B
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 08:27:28 -0700 (PDT)
Message-ID: <c7da39fb-f60d-ac0c-ddc3-cb9b9280081d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680016929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BCr0MFHrR6MEWKgrp+OaJbi5BYNICOILw+ISbtBAAqI=;
        b=Pl+YFzpLoz8PHHYEZesHirepR3z6/G+CUor47ZZwJQ7s7sCSE1Fvn9m3Z77xU2lmU1Wps1
        P3JULBCX9xe5H+6DjZP6jXK3G45Hta9iZQlCHw0u8rGLj7gecicwpy3sZN8USVxi1JlmnE
        hyhmiYd0VxmtpljLODnMhJ2Yk+G/XkI=
Date:   Tue, 28 Mar 2023 16:22:04 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
        mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com> <ZA9Nbll8+xHt4ygd@nanopsycho>
 <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
 <ZBA8ofFfKigqZ6M7@nanopsycho>
 <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBGOWQW+1JFzNsTY@nanopsycho>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <ZBGOWQW+1JFzNsTY@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 09:22, Jiri Pirko wrote:
> Tue, Mar 14, 2023 at 06:50:57PM CET, arkadiusz.kubalewski@intel.com wrote:
>>> From: Jiri Pirko <jiri@resnulli.us>
>>> Sent: Tuesday, March 14, 2023 10:22 AM
>>>
>>> Mon, Mar 13, 2023 at 11:59:32PM CET, vadim.fedorenko@linux.dev wrote:
>>>> On 13.03.2023 16:21, Jiri Pirko wrote:
>>>>> Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:
>>>
>>> [...]
>>>
>>>
>>>>>> diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>>>>>> new file mode 100644
>>>>>> index 000000000000..d3926f2a733d
>>>>>> --- /dev/null
>>>>>> +++ b/drivers/dpll/Makefile
>>>>>> @@ -0,0 +1,10 @@
>>>>>> +# SPDX-License-Identifier: GPL-2.0
>>>>>> +#
>>>>>> +# Makefile for DPLL drivers.
>>>>>> +#
>>>>>> +
>>>>>> +obj-$(CONFIG_DPLL)          += dpll_sys.o
>>>>>
>>>>> What's "sys" and why is it here?
>>>>
>>>> It's an object file for the subsystem. Could be useful if we will have
>>>> drivers
>>>> for DPLL-only devices.
>>>
>>> Yeah, but why "sys"? I don't get what "sys" means here.
>>> Can't this be just "dpll.o"?
>>>
>>>
>>>>
>>>>>> +dpll_sys-y                  += dpll_core.o
>>>>>> +dpll_sys-y                  += dpll_netlink.o
>>>>>> +dpll_sys-y                  += dpll_nl.o
>>>>>> +
>>>
>>> [...]
>>>
>>>
>>>>>> +struct dpll_device *
>>>>>> +dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module
>>>>>> *module)
>>>>>> +{
>>>>>> +	struct dpll_device *dpll, *ret = NULL;
>>>>>> +	unsigned long index;
>>>>>> +
>>>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>>>> +	xa_for_each(&dpll_device_xa, index, dpll) {
>>>>>> +		if (dpll->clock_id == clock_id &&
>>>>>> +		    dpll->dev_driver_id == dev_driver_id &&
>>>>>
>>>>> Why you need "dev_driver_id"? clock_id is here for the purpose of
>>>>> identification, isn't that enough for you.
>>>>
>>>> dev_driver_id is needed to provide several DPLLs from one device. In ice
>>>> driver
>>>> implementation there are 2 different DPLLs - to recover from PPS input and
>>>> to
>>>> recover from Sync-E. I believe there is only one clock, that's why clock id
>>>> is the same for both of them. But Arkadiusz can tell more about it.
>>>
>>> Okay, I see. Clock_id is the same. Could we have index for pin, could
>>> this be index too:
>>>
>>> dpll_device_get(u64 clock_id, u32 device_index, struct module *module);
>>> dpll_pin_get(u64 clock_id, u32 pin_index, struct module *module,
>>> 	     const struct dpll_pin_properties *prop);
>>>
>>> This way it is consistent, driver provides custom index for both dpll
>>> device and dpll pin.
>>>
>>> Makes sense?
>>>
>>
>> IMHO, Yes this better shows the intentions.
> 
> Ok.
> 
> 
>>
>>>
>>>>>
>>>>> Plus, the name is odd. "dev_driver" should certainly be avoided.
>>>>
>>>> Simply id doesn't tell anything either. dpll_dev_id?
>>>
>>> Yeah, see above.
>>>
>>>
>>>>
>>>>>> +		    dpll->module == module) {
>>>>>> +			ret = dpll;
>>>>>> +			refcount_inc(&ret->refcount);
>>>>>> +			break;
>>>>>> +		}
>>>>>> +	}
>>>>>> +	if (!ret)
>>>>>> +		ret = dpll_device_alloc(clock_id, dev_driver_id, module);
>>>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>>>> +
>>>>>> +	return ret;
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(dpll_device_get);
>>>>>> +
>>>>>> +/**
>>>>>> + * dpll_device_put - decrease the refcount and free memory if possible
>>>>>> + * @dpll: dpll_device struct pointer
>>>>>> + *
>>>>>> + * Drop reference for a dpll device, if all references are gone, delete
>>>>>> + * dpll device object.
>>>>>> + */
>>>>>> +void dpll_device_put(struct dpll_device *dpll)
>>>>>> +{
>>>>>> +	if (!dpll)
>>>>>> +		return;
>>>>>
>>>>> Remove this check. The driver should not call this with NULL.
>>>>
>>>> Well, netdev_put() has this kind of check. As well as spi_dev_put() or
>>>> i2c_put_adapter() at least. Not sure I would like to avoid a bit of safety.
>>>
>>> IDK, maybe for historical reasons. My point is, id driver is callin
>>> this with NULL, there is something odd in the driver flow. Lets not
>>> allow that for new code.
>>>
>>>
>>>>
>>>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>>>> +	if (refcount_dec_and_test(&dpll->refcount)) {
>>>>>> +		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
>>>>>
>>>>> ASSERT_DPLL_NOT_REGISTERED(dpll);
>>>>
>>>> Good point!
>>>>
>>>>>> +		xa_destroy(&dpll->pin_refs);
>>>>>> +		xa_erase(&dpll_device_xa, dpll->id);
>>>>>> +		kfree(dpll);
>>>>>> +	}
>>>>>> +	mutex_unlock(&dpll_device_xa_lock);
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(dpll_device_put);
>>>>>> +
>>>>>> +/**
>>>>>> + * dpll_device_register - register the dpll device in the subsystem
>>>>>> + * @dpll: pointer to a dpll
>>>>>> + * @type: type of a dpll
>>>>>> + * @ops: ops for a dpll device
>>>>>> + * @priv: pointer to private information of owner
>>>>>> + * @owner: pointer to owner device
>>>>>> + *
>>>>>> + * Make dpll device available for user space.
>>>>>> + *
>>>>>> + * Return:
>>>>>> + * * 0 on success
>>>>>> + * * -EINVAL on failure
>>>>>> + */
>>>>>> +int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>>>>>> +			 struct dpll_device_ops *ops, void *priv,
>>>>>> +			 struct device *owner)
>>>>>> +{
>>>>>> +	if (WARN_ON(!ops || !owner))
>>>>>> +		return -EINVAL;
>>>>>> +	if (WARN_ON(type <= DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
>>>>>> +		return -EINVAL;
>>>>>> +	mutex_lock(&dpll_device_xa_lock);
>>>>>> +	if (ASSERT_DPLL_NOT_REGISTERED(dpll)) {
>>>>>> +		mutex_unlock(&dpll_device_xa_lock);
>>>>>> +		return -EEXIST;
>>>>>> +	}
>>>>>> +	dpll->dev.bus = owner->bus;
>>>>>> +	dpll->parent = owner;
>>>>>> +	dpll->type = type;
>>>>>> +	dpll->ops = ops;
>>>>>> +	dev_set_name(&dpll->dev, "%s_%d", dev_name(owner),
>>>>>> +		     dpll->dev_driver_id);
>>>>>
>>>>> This is really odd. As a result, the user would see something like:
>>>>> pci/0000:01:00.0_1
>>>>> pci/0000:01:00.0_2
>>>>>
>>>>> I have to say it is confusing. In devlink, is bus/name and the user
>>>>> could use this info to look trough sysfs. Here, 0000:01:00.0_1 is not
>>>>> there. Also, "_" might have some meaning on some bus. Should not
>>>>> concatename dev_name() with anything.
>>>>>
>>>>> Thinking about this some more, the module/clock_id tuple should be
>>>>> uniqueue and stable. It is used for dpll_device_get(), it could be used
>>>>> as the user handle, can't it?
>>>>> Example:
>>>>> ice/c92d02a7129f4747
>>>>> mlx5/90265d8bf6e6df56
>>>>>
>>>>> If you really need the "dev_driver_id" (as I believe clock_id should be
>>>>> enough), you can put it here as well:
>>>>> ice/c92d02a7129f4747/1
>>>>> ice/c92d02a7129f4747/2
>>>>>
>>>>
>>>> Looks good, will change it
>>>
>>> Great.
>>>
>>>
>>>>
>>>>> This would also be beneficial for mlx5, as mlx5 with 2 PFs would like to
>>>>> share instance of DPLL equally, there is no "one clock master". >
>>>
>>> [...]
>>>
>>>
>>>>>> +	pin->prop.description = kstrdup(prop->description, GFP_KERNEL);
>>>>>> +	if (!pin->prop.description) {
>>>>>> +		ret = -ENOMEM;
>>>>>> +		goto release;
>>>>>> +	}
>>>>>> +	if (WARN_ON(prop->type <= DPLL_PIN_TYPE_UNSPEC ||
>>>>>> +		    prop->type > DPLL_PIN_TYPE_MAX)) {
>>>>>> +		ret = -EINVAL;
>>>>>> +		goto release;
>>>>>> +	}
>>>>>> +	pin->prop.type = prop->type;
>>>>>> +	pin->prop.capabilities = prop->capabilities;
>>>>>> +	pin->prop.freq_supported = prop->freq_supported;
>>>>>> +	pin->prop.any_freq_min = prop->any_freq_min;
>>>>>> +	pin->prop.any_freq_max = prop->any_freq_max;
>>>>>
>>>>> Make sure that the driver maintains prop (static const) and just save
>>>>> the pointer. Prop does not need to be something driver needs to change.
>>>>>
>>>>
>>>> What's the difference? For ptp_ocp, we have the same configuration for all
>>>> ext pins and the allocator only changes the name of the pin. Properties of
>>>> the DPLL pins are stored within the pin object, not the driver, in this
>>> case.
>>>> Not sure if the pointer way is much better...
>>>
>>> For things like this it is common to have static const array in the
>>> driver, like:
>>>
>>> static const struct dpll_pin_properties dpll_pin_props[] = {
>>> 	{
>>> 		.description = "SMA0",
>>> 		.freq_supported = DPLL_PIN_FREQ_SUPP_MAX,
>>> 		.type = DPLL_PIN_TYPE_EXT,
>>> 		.any_freq_max = 10000000,
>>> 		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>>> 	},
>>> 	{
>>> 		.description = "SMA1",
>>> 		.freq_supported = DPLL_PIN_FREQ_SUPP_MAX,
>>> 		.type = DPLL_PIN_TYPE_EXT,
>>> 		.any_freq_max = 10000000,
>>> 		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>>> 	},
>>> 	{
>>> 		.description = "SMA2",
>>> 		.freq_supported = DPLL_PIN_FREQ_SUPP_MAX,
>>> 		.type = DPLL_PIN_TYPE_EXT,
>>> 		.any_freq_max = 10000000,
>>> 		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>>> 	},
>>> 	{
>>> 		.description = "SMA3",
>>> 		.freq_supported = DPLL_PIN_FREQ_SUPP_MAX,
>>> 		.type = DPLL_PIN_TYPE_EXT,
>>> 		.any_freq_max = 10000000,
>>> 		.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>>> 	},
>>> };
>>>
>>> Here you have very nice list of pins, the reader knows right away what
>>> is happening.
>>>
>>> Thinking about "description" name, I think would be more appropriate to
>>> name this "label" as it represents user-facing label on the connector,
>>> isn't it? Does not describe anything.
>>>
>>
>> "label" seems good.
> 
> Ok.
> 
> 
>>
>>>
>>>>
>>>>>
>>>
>>> [...]
>>>
>>>
>>>>
>>>>>
>>>>>> +	     const struct dpll_pin_properties *prop)
>>>>>> +{
>>>>>> +	struct dpll_pin *pos, *ret = NULL;
>>>>>> +	unsigned long index;
>>>>>> +
>>>>>> +	mutex_lock(&dpll_pin_xa_lock);
>>>>>> +	xa_for_each(&dpll_pin_xa, index, pos) {
>>>>>> +		if (pos->clock_id == clock_id &&
>>>>>> +		    pos->dev_driver_id == device_drv_id &&
>>>>>> +		    pos->module == module) {
>>>>>
>>>>> Compare prop as well.
>>>>>
>>>>> Can't the driver_id (pin index) be something const as well? I think it
>>>>> should. And therefore it could be easily put inside.
>>>>>
>>>>
>>>> I think clock_id + dev_driver_id + module should identify the pin exactly.
>>>> And now I think that *prop is not needed here at all. Arkadiusz, any
>>>> thoughts?
>>>
>>> IDK, no strong opinion on this. I just thought it may help to identify
>>> the pin and avoid potential driver bugs. (Like registering 2 pins with
>>> the same properties).
>>>
>>
>> It would make most sense if pin_index would be a part of *prop.
> 
> Hmm. I see one example where it would not be suitable:
> NIC with N physical ports. You, as a driver, register one pin per
> physical port. You have one static const prop and pass the pointer to if
> for every registration call of N pins, each time with different
> pin_index.
> 
> So from what I see, the prop describes a flavour of pin in the driver.
> In the exaple above, it is still the same SyncE pin, with the same ops.
> Only multiple instances of that distinguished by pin_index and priv.
> 
> Makes sense?
> 
> 
>>
>>> [...]
>>>
>>>
>>>>>> +/**
>>>>>> + * dpll_pin_register - register the dpll pin in the subsystem
>>>>>> + * @dpll: pointer to a dpll
>>>>>> + * @pin: pointer to a dpll pin
>>>>>> + * @ops: ops for a dpll pin ops
>>>>>> + * @priv: pointer to private information of owner
>>>>>> + * @rclk_device: pointer to recovered clock device
>>>>>> + *
>>>>>> + * Return:
>>>>>> + * * 0 on success
>>>>>> + * * -EINVAL - missing dpll or pin
>>>>>> + * * -ENOMEM - failed to allocate memory
>>>>>> + */
>>>>>> +int
>>>>>> +dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>>>>> +		  struct dpll_pin_ops *ops, void *priv,
>>>>>> +		  struct device *rclk_device)
>>>>>
>>>>> Wait a second, what is this "struct device *"? Looks very odd.
>>>>>
>>>>>
>>>>>> +{
>>>>>> +	const char *rclk_name = rclk_device ? dev_name(rclk_device) :
>>>>>> NULL;
>>>>>
>>>>> If you need to store something here, store the pointer to the device
>>>>> directly. But this rclk_device seems odd to me.
>>>>> Dev_name is in case of PCI device for example 0000:01:00.0? That alone
>>>>> is incomplete. What should it server for?
>>>>>
>>>>
>>>> Well, these questions go to Arkadiusz...
>>>
>>
>>
>> [ copy paste my answer from previous response ]
> 
> Does not help, see below.
> 
> 
>> If pin is able to recover signal from some device this shall convey that
>> device struct pointer.
> 
> But one device (struct device instance) could easily have multiple
> netdev instances attached and therefore mutiple sources of recovered
> signal.
> 
> mlxsw driver is one of the examples of this 1:N mapping between device
> and netdev.
> 
> 
>> Name of that device is later passed to the user with DPLL_A_PIN_RCLK_DEVICE
>> attribute.
>> Sure we can have pointer to device and use dev_name (each do/dump) on netlink
>> part. But isn't it better to have the name ready to use there?
>>
>> It might be incomplete only if one device would have some kind of access to
>> a different bus? I don't think it is valid use case.
> 
> Very easily, auxiliary_bus. That is actually the case already for mlx5.
> 
> 
>>
>> Basically the driver will refer only to the devices handled by that driver,
>> which means if dpll is on some bus, also all the pins are there, didn't notice
>> the need to have bus here as well.
> 
> What is the motivation exactly? Is it only SyncE? In case it is, the
> link to the pin should be added from the other side, carried over
> RTNetlink msg of a netdev associated with pin. I will add a patch for
> this.
> 
> Do you need to expose any other recovered clock device source?
> 
> 
>>
>>> Okay.
>>>
>>> [...]
>>>
>>>
>>>>>> + * dpll_pin_get_by_idx - find a pin ref on dpll by pin index
>>>>>> + * @dpll: dpll device pointer
>>>>>> + * @idx: index of pin
>>>>>> + *
>>>>>> + * Find a reference to a pin registered with given dpll and return
>>>>>> its pointer.
>>>>>> + *
>>>>>> + * Return:
>>>>>> + * * valid pointer if pin was found
>>>>>> + * * NULL if not found
>>>>>> + */
>>>>>> +struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx)
>>>>>> +{
>>>>>> +	struct dpll_pin_ref *pos;
>>>>>> +	unsigned long i;
>>>>>> +
>>>>>> +	xa_for_each(&dpll->pin_refs, i, pos) {
>>>>>> +		if (pos && pos->pin && pos->pin->dev_driver_id == idx)
>>>>>
>>>>> How exactly pos->pin could be NULL?
>>>>>
>>>>> Also, you are degrading the xarray to a mere list here with lookup like
>>>>> this. Why can't you use the pin index coming from driver and
>>>>> insert/lookup based on this index?
>>>>>
>>>> Good point. We just have to be sure, that drivers provide 0-based indexes for
>>>> their pins. I'll re-think it.
>>>
>>> No, driver can provide indexing which is completely up to his decision.
>>> You should use xa_insert() to insert the entry at specific index. See
>>> devl_port_register for inspiration where it is done exactly like this.
>>>
>>> And this should be done in exactly the same way for both pin and device.
>>>
>>
>> Yes, I agree seems doable and better then it is now.
>>
>> [...]
>>
>>>>>> +static int
>>>>>> +dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_device
>>>>>> *dpll)
>>>>>> +{
>>>>>> +	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
>>>>>
>>>>> Why exactly do we need this dua--handle scheme? Why do you need
>>>>> unpredictable DPLL_A_ID to be exposed to userspace?
>>>>> It's just confusing.
>>>>>
>>>> To be able to work with DPLL per integer after iterator on the list deducts
>>>> which DPLL device is needed. It can reduce the amount of memory copies and
>>>> simplify comparisons. Not sure why it's confusing.
>>>
>>> Wait, I don't get it. Could you please explain a bit more?
>>>
>>> My point is, there should be not such ID exposed over netlink
>>> You don't need to expose it to userspace. The user has well defined
>>> handle as you agreed with above. For example:
>>>
>>> ice/c92d02a7129f4747/1
>>> ice/c92d02a7129f4747/2
>>>
>>> This is shown in dpll device GET/DUMP outputs.
>>> Also user passes it during SET operation:
>>> $ dplltool set ice/c92d02a7129f4747/1 mode auto
>>>
>>> Isn't that enough stable and nice?
>>>
>>
>> I agree with Vadim, this is rather to be used by a daemon tools, which
>> would get the index once, then could use it as long as device is there.
> 
> So basically you say, you can have 2 approaches in app:
> 1)
> id = dpll_device_get_id("ice/c92d02a7129f4747/1")
> dpll_device_set(id, something);
> dpll_device_set(id, something);
> dpll_device_set(id, something);
> 2):
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> 
> What is exactly benefit of the first one? Why to have 2 handles? Devlink
> is a nice example of 2) approach, no problem there.
> 
> Perhaps I'm missing something, but looks like you want the id for no
> good reason and this dual-handle scheme just makes things more
> complicated with 0 added value.

I would like to avoid any extra memory copies or memory checks when it's 
possible to compare single u32/u64 index value. I might be invisible on 
a single host setup, but running monitoring at scale which will parse 
and compare string on every get/event can burn a bit of compute capacity.

> 
> 
>>
>>>
>>>>
>>>>>
>>>>>> +		return -EMSGSIZE;
>>>>>> +	if (nla_put_string(msg, DPLL_A_BUS_NAME, dev_bus_name(&dpll-
>>>>>> dev)))
>>>>>> +		return -EMSGSIZE;
>>>>>> +	if (nla_put_string(msg, DPLL_A_DEV_NAME, dev_name(&dpll->dev)))
>>>>>> +		return -EMSGSIZE;
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>
>>>> [...]
>>>>
>>>>>> +
>>>>>> +static int
>>>>>> +dpll_msg_add_pins_on_pin(struct sk_buff *msg, struct dpll_pin *pin,
>>>>>> +			 struct netlink_ext_ack *extack)
>>>>>> +{
>>>>>> +	struct dpll_pin_ref *ref = NULL;
>>>>>
>>>>> Why this needs to be initialized?
>>>>>
>>>> No need, fixed.
>>>>
>>>>
>>>>>
>>>>>> +	enum dpll_pin_state state;
>>>>>> +	struct nlattr *nest;
>>>>>> +	unsigned long index;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	xa_for_each(&pin->parent_refs, index, ref) {
>>>>>> +		if (WARN_ON(!ref->ops->state_on_pin_get))
>>>>>> +			return -EFAULT;
>>>>>> +		ret = ref->ops->state_on_pin_get(pin, ref->pin, &state,
>>>>>> +						 extack);
>>>>>> +		if (ret)
>>>>>> +			return -EFAULT;
>>>>>> +		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
>>>>>> +		if (!nest)
>>>>>> +			return -EMSGSIZE;
>>>>>> +		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>>>>> +				ref->pin->dev_driver_id)) {
>>>>>> +			ret = -EMSGSIZE;
>>>>>> +			goto nest_cancel;
>>>>>> +		}
>>>>>> +		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
>>>>>> +			ret = -EMSGSIZE;
>>>>>> +			goto nest_cancel;
>>>>>> +		}
>>>>>> +		nla_nest_end(msg, nest);
>>>>>> +	}
>>>>>
>>>>> How is this function different to dpll_msg_add_pin_parents()?
>>>>> Am I lost? To be honest, this x_on_pin/dpll, parent, refs dance is quite
>>>>> hard to follow for me :/
>>>>>
>>>>> Did you get lost here as well? If yes, this needs some serious think
>>>>> through :)
>>>>>
>>>>
>>>> Let's re-think it again. Arkadiuzs, do you have clear explanation of the
>>>> relationship between these things?
>>>
>>
>> [ copy paste my answer from previous response ]
>> No, it is just leftover I didn't catch, we can leave one function and use it in
>> both cases. Sorry about that, great catch!
> 
> Hmm, ok. I'm still lost a bit with all the referencing and cross
> referencing, I wonder if it could be made a bit simpler and/or easier to
> read and follow.
> 
> 
>>
>> [...]
>>
>>>>>> +	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>>>>
>>>>> Is it "ID" or "INDEX" (IDX). Please make this consistent in the whole
>>>>> code.
>>>>>
>>>>
>>>> I believe it's INDEX which is provided by the driver. I'll think about
>>>> renaming,
>>>> but suggestions are welcome.
>>>
>>> Let's use "index" and "INDEX" internalla and in Netlink attr names as
>>> well then.
>>>
>>
>> For me makes sense to have a common name instead of origin-based one.
> 
> What do you mean by this?
> 
> 
>>
>>> [...]
>>>
>>>
>>>>
>>>>>
>>>>>> +	int rem, ret = -EINVAL;
>>>>>> +	struct nlattr *a;
>>>>>> +
>>>>>> +	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>>>>> +			  genlmsg_len(info->genlhdr), rem) {
>>>>>
>>>>> This is odd. Why you iterace over attrs? Why don't you just access them
>>>>> directly, like attrs[DPLL_A_PIN_FREQUENCY] for example?
>>>>>
>>>>
>>>> I had some unknown crashes when I was using such access. I might have lost
>>>> some checks, will try it again.
>>>
>>> Odd, yet definitelly debuggable though :)
>>>
>>> [...]
>>>
>>>
>>>>>> +int dpll_pin_pre_dumpit(struct netlink_callback *cb)
>>>>>> +{
>>>>>> +	mutex_lock(&dpll_pin_xa_lock);
>>>>>
>>>>> ABBA deadlock here, see dpll_pin_register() for example where the lock
>>>>> taking order is opposite.
>>>>>
>>>>
>>>> Now I see an ABBA deadlock here, as well as in function before. Not sure
>>>> how to
>>>> solve it here. Any thoughts?
>>>
>>> Well, here you can just call dpll_pre_dumpit() before
>>> mutex_lock(&dpll_pin_xa_lock)
>>> to take the locks in the same order.
>>>
>>
>> This double lock doesn't really improve anything.
>> Any objections on having single mutex/lock for access the dpll subsystem?
> 
> Yeah, we had it in devlink and then we spent a lot of a time to get rid
> of it. Now we have per-instance locking. Here, it would be
> per-dpll-device locking.
> 
> No strong opinion, perhaps on case of dpll one master lock is enough.
> Perhaps Jakub would have some opinion on this.
> 
> 
>>
>>>
>>>>
>>>>>
>>>>>> +
>>>>>> +	return dpll_pre_dumpit(cb);
>>>>>> +}
>>>>>> +
>>>>>> +int dpll_pin_post_dumpit(struct netlink_callback *cb)
>>>>>> +{
>>>>>> +	mutex_unlock(&dpll_pin_xa_lock);
>>>>>> +
>>>>>> +	return dpll_post_dumpit(cb);
>>>>>> +}
>>>>>> +
>>>>>> +static int
>>>>>> +dpll_event_device_change(struct sk_buff *msg, struct dpll_device
>>>>>> *dpll,
>>>>>> +			 struct dpll_pin *pin, struct dpll_pin *parent,
>>>>>> +			 enum dplla attr)
>>>>>> +{
>>>>>> +	int ret = dpll_msg_add_dev_handle(msg, dpll);
>>>>>> +	struct dpll_pin_ref *ref = NULL;
>>>>>> +	enum dpll_pin_state state;
>>>>>> +
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>> +	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin-
>>>>>> dev_driver_id))
>>>>>> +		return -EMSGSIZE;
>>>>>
>>>>> I don't really understand why you are trying figure something new and
>>>>> interesting with the change notifications. This object mix and random
>>>>> attrs fillup is something very wrong and makes userspace completely
>>>>> fuzzy about what it is getting. And yet it is so simple:
>>>>> You have 2 objects, dpll and pin, please just have:
>>>>> dpll_notify()
>>>>> dpll_pin_notify()
>>>>> and share the attrs fillup code with pin_get() and dpll_get() callbacks.
>>>>> No need for any smartness. Have this dumb and simple.
>>>>>
>>>>> Think about it more as about "object-state-snapshot" than "atomic-change"
>>>>
>>>> But with full object-snapshot user space app will lose the information about
>>>> what exactly has changed. The reason to have this event is to provide the
>>>> attributes which have changed. Otherwise, the app should have full snapshot
>>>> and
>>>> compare all attributes to figure out changes and that's might not be great
>>>> idea.
>>>
>>> Wait, are you saying that the app is stateless? Could you provide
>>> example use cases?
>>>
>> >From what I see, the app managing dpll knows the state of the device and
>>> pins, it monitors for the changes and saves new state with appropriate
>>> reaction (might be some action or maybe just log entry).
>>>
>>
>> It depends on the use case, right? App developer having those information knows
>> what has changed, thus can react in a way it thinks is most suitable.
>> IMHO from user perspective it is good to have a notification which actually
>> shows it's reason, so proper flow could be assigned to handle the reaction.
> 
> Again, could you provide me specific example in which this is needed?
> I may be missing something, but I don't see how it can bring
> and benefit. It just makes the live of the app harder because it has to
> treat the get and notify messages differently.
> 
> It is quite common for app to:
> init:
> 1) get object state
> 2) store it
> 3) apply configuration
> runtime:
> 1) listen to object state change
> 2) store it
> 3) apply configuration
> 
> Same code for both.

Well, I'm thinking about simple monitoring app which will wait for the 
events and create an alert if the changes coming from the event differ 
from the "allowed configs". In this case no real reason to store whole 
object state, but the changes in events are very useful.

> 
> 
> 
> 
>>
>>>
>>>>
>>>>>
>>>>>> +
>>>>>> +	switch (attr) {
>>>>>> +	case DPLL_A_MODE:
>>>>>> +		ret = dpll_msg_add_mode(msg, dpll, NULL);
>>>>>> +		break;
>>>>>> +	case DPLL_A_SOURCE_PIN_IDX:
>>>>>> +		ret = dpll_msg_add_source_pin_idx(msg, dpll, NULL);
>>>>>> +		break;
>>>>>> +	case DPLL_A_LOCK_STATUS:
>>>>>> +		ret = dpll_msg_add_lock_status(msg, dpll, NULL);
>>>>>> +		break;
>>>>>> +	case DPLL_A_TEMP:
>>>>>> +		ret = dpll_msg_add_temp(msg, dpll, NULL);
>>>>>> +		break;
>>>>>> +	case DPLL_A_PIN_FREQUENCY:
>>>>>> +		ret = dpll_msg_add_pin_freq(msg, pin, NULL, false);
>>>>>> +		break;
>>>>>> +	case DPLL_A_PIN_PRIO:
>>>>>> +		ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>>>>> +		if (!ref)
>>>>>> +			return -EFAULT;
>>>>>> +		ret = dpll_msg_add_pin_prio(msg, pin, ref, NULL);
>>>>>> +		break;
>>>>>> +	case DPLL_A_PIN_STATE:
>>>>>> +		if (parent) {
>>>>>> +			ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
>>>>>> +			if (!ref)
>>>>>> +				return -EFAULT;
>>>>>> +			if (!ref->ops || !ref->ops->state_on_pin_get)
>>>>>> +				return -EOPNOTSUPP;
>>>>>> +			ret = ref->ops->state_on_pin_get(pin, parent, &state,
>>>>>> +							 NULL);
>>>>>> +			if (ret)
>>>>>> +				return ret;
>>>>>> +			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>>>>> +					parent->dev_driver_id))
>>>>>> +				return -EMSGSIZE;
>>>>>> +		} else {
>>>>>> +			ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>>>>> +			if (!ref)
>>>>>> +				return -EFAULT;
>>>>>> +			ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref,
>>>>>> +							     NULL);
>>>>>> +			if (ret)
>>>>>> +				return ret;
>>>>>> +		}
>>>>>> +		break;
>>>>>> +	default:
>>>>>> +		break;
>>>>>> +	}
>>>>>> +
>>>>>> +	return ret;
>>>>>> +}
>>>>>> +
>>>>>> +static int
>>>>>> +dpll_send_event_create(enum dpll_event event, struct dpll_device *dpll)
>>>>>> +{
>>>>>> +	struct sk_buff *msg;
>>>>>> +	int ret = -EMSGSIZE;
>>>>>> +	void *hdr;
>>>>>> +
>>>>>> +	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>>>>> +	if (!msg)
>>>>>> +		return -ENOMEM;
>>>>>> +
>>>>>> +	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>>>>>> +	if (!hdr)
>>>>>> +		goto out_free_msg;
>>>>>> +
>>>>>> +	ret = dpll_msg_add_dev_handle(msg, dpll);
>>>>>> +	if (ret)
>>>>>> +		goto out_cancel_msg;
>>>>>> +	genlmsg_end(msg, hdr);
>>>>>> +	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
>>>>>> +
>>>>>> +	return 0;
>>>>>> +
>>>>>> +out_cancel_msg:
>>>>>> +	genlmsg_cancel(msg, hdr);
>>>>>> +out_free_msg:
>>>>>> +	nlmsg_free(msg);
>>>>>> +
>>>>>> +	return ret;
>>>>>> +}
>>>>>> +
>>>>>> +static int
>>>>>> +dpll_send_event_change(struct dpll_device *dpll, struct dpll_pin *pin,
>>>>>> +		       struct dpll_pin *parent, enum dplla attr)
>>>>>> +{
>>>>>> +	struct sk_buff *msg;
>>>>>> +	int ret = -EMSGSIZE;
>>>>>> +	void *hdr;
>>>>>> +
>>>>>> +	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>>>>> +	if (!msg)
>>>>>> +		return -ENOMEM;
>>>>>> +
>>>>>> +	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0,
>>>>>> +			  DPLL_EVENT_DEVICE_CHANGE);
>>>>>
>>>>> I don't really get it. Why exactly you keep having this *EVENT* cmds?
>>>>> Why per-object NEW/GET/DEL cmds shared with get genl op are not enough?
>>>>> I have to be missing something.
>>>>
>>>> Changes might come from other places, but will affect the DPLL device and we
>>>> have to notify users in this case.
>>>
>>> I'm not sure I follow. There are 2 scenarios for change:
>>> 1) user originated - user issues set of something
>>> 2) driver originated - something changes in HW, driver propagates that
>>>
>>> With what I suggest, both scenarios work of course. My point is, user
>>> knows very well the objects: device and pin, he knows the format or
>>> messages that are related to GET/DUMP/SET operations of both. The
>>> notification should have the same format, that is all I say.
>>>
>>> Btw, you can see devlink code for example how the notifications like
>>> this are implemented and work.
>>>
>>
>> Devlink packs all the info into a netlink message and notifies with it, isn't
>> it that it has all the info "buffered" in its structures?
> 
> Not really. Ops are there as well.
> 
> 
>> A dpll subsystem keeps only some of the info in its internal structures, but
>> for most of it it has to question the driver. It would do it multiple times
>> i.e. if there would be a change on a pin connected to multiple dpll devices.
>>
>> With current approach the notifications are pretty light to the subsystem as
>> well as for the registered clients, and as you suggested with having info of
>> what actually changed the userspace could implement a stateless daemon right
>> away.
> 
> Okay, examples? I really can't see how this stateless deamon could be
> implemented, but perhaps I lack better imagination :/
> 
> 
>>
>> Thank you,
>> Arkadiusz

