Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A883289F46
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgJJIUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 04:20:06 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:22214 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbgJJINJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 04:13:09 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d29 with ME
        id e8Cm230022lQRaH038Cs69; Sat, 10 Oct 2020 10:13:00 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 10 Oct 2020 10:13:00 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces
Date:   Sat, 10 Oct 2020 17:12:11 +0900
Message-Id: <20201010081211.392860-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <c501e9ea-5412-fa90-b403-d34ca4720c89@pengutronix.de>
References: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr> <20201002154219.4887-7-mailhol.vincent@wanadoo.fr> <c501e9ea-5412-fa90-b403-d34ca4720c89@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just one header file for now :)

Thanks for the review, very constructive comments :)

I acknowledge all the trivial fixes (space, new line, // comments,
naming...), those will be fixed in v4 (will also review other files
for similar mistakes). In this reply, I will only focus on the points
which need explanations.

v4 will come a bit later.


> > +/* Threshold on consecutive CAN_STATE_ERROR_PASSIVE. If we receive
> > + * ES58X_CONSECUTIVE_ERR_PASSIVE_MAX times the event
> > + * ES58X_ERR_CRTL_PASSIVE in a row without any successful Rx or Tx,
> > + * we force the device to switch to CAN_STATE_BUS_OFF state.
> > + */
> > +#define ES58X_CONSECUTIVE_ERR_PASSIVE_MAX 254
> 
> Does the device recover from bus off automatically or why is this needed?
> 

Will be answered below together with your other question on
@err_passive_before_rtx_success of struct es58x_priv.

> > +
> > +enum es58x_physical_media {
> > +	ES58X_MEDIA_HIGH_SPEED = 1,
> > +	ES58X_MEDIA_FAULT_TOLERANT = 2
> 
> You mean with FAULT_TOLERANT you mean ISO 11898-3? According to [1] they should
> be named low speed.

Two comments:
 1/ Yes, this is "low speed". I did not know about the ISO 11898-3,
    thanks for the hint.
 2/ After double checking, this option is not supported by the devices
    in scope of this driver (other devices of the ESxxx portfolio
    might support it).
This option will be removed in v4.

> > +};
> > +
> > +enum es58x_samples_per_bit {
> > +	ES58X_ONE_SAMPLE_PER_BIT = 1,
> > +
> > +	/* Some CAN controllers do not support three samples per
> > +	 * bit. In this case the default value of one sample per bit
> > +	 * is used, even if the configuration is set to
> > +	 * ES58X_THREE_SAMPLES_PER_BIT.
> > +	 */
> 
> Can you autodetect the controller and avoid announcing tripple sample mode to
> the driver framework?

Will be addressed in v4. Your remarks made me realized that some of
the controller modes might not have been announced correctly. Will
double check the other CAN_CTRLMODE_* as well.

> > +	ES58X_THREE_SAMPLES_PER_BIT = 2
> > +};
> > +
> > +enum es58x_sync_edge {
> > +	/* ISO CAN specification defines the use of a single edge
> > +	 * synchronization. The synchronization should be done on
> > +	 * recessive to dominant level change.
> > +	 */
> > +	ES58X_SINGLE_SYNC_EDGE = 1,
> > +
> > +	/* In addition to the ISO CAN specification, a double
> > +	 * synchronization is also supported: recessive to dominant
> > +	 * level change and dominant to recessive level change.
> > +	 */
> > +	ES58X_DUAL_SYNC_EDGE = 2
> 
> >We don't have a setting in the CAN framework for this....

The idea here was just to let know people that the option exists so
that if someone needs the feature one day, he or she can hack the
driver for his or her own use.

Is it OK to keep it (maybe with a comment such as "not implemented in
this driver") or should it be simply removed?

There are other similar references in other files. Will change these
accordingly to your answer on above question.

> > +/**
> > + * struct es58x_abstracted_can_frame - Common structure to hold can
> > + *	frame information.
> 
> why do you have an itermediate can frame format? We have the struct can_frame
> and the skb for this.

The goal of this structure was to factorize code when calculating the
CAN flags. I will try to rethink this part in v4.

> > +union es58x_urb_cmd {
> > +	u8 raw_cmd[0];
> 
> I have to polish my C, what's an empty array in the beginning of a struct?

This is not a struct but a union (it would indeed make no sense at the
beginning of a struct).

Because it is in a union, the order of the fields does not make a
difference (if you prefer this to be at the end, I can fix it).

This field is used to cast the union to an u8 array. Because the
length is unknown it is declared as empty.

For reference, I could at least find a few other references of union
starting with an empty array in the kernel. One example here:
https://elixir.bootlin.com/linux/latest/source/include/linux/bpf.h#L821

> 
> > +/**
> > + * struct es58x_priv - All information specific to a can channel.
> > + * @can: struct can_priv must be the first member (Socket CAN relies
> > + *	on the fact that function netdev_priv() returns a pointer to
> > + *	a struct can_priv).
> > + * @es58x_dev: pointer to the corresponding ES58X device.
> > + * @echo_skb_spinlock: Spinlock to protect the access to the echo skb
> > + *	FIFO.
> > + * @current_packet_idx: Keeps track of the packet indexes.
> > + * @echo_skb_tail_idx: beginning of the echo skb FIFO, i.e. index of
> > + *	the first element.
> > + * @echo_skb_head_idx: end of the echo skb FIFO plus one, i.e. first
> > + *	free index.
> > + * @num_echo_skb: actual number of elements in the FIFO. Thus, the end
> > + *	of the FIFO is echo_skb_head = (echo_skb_tail_idx +
> > + *	num_echo_skb) % can.echo_skb_max.
> > + * @tx_urb: Used as a buffer to concatenate the TX messages and to do
> > + *	a bulk send. Please refer to es58x_start_xmit() for more
> > + *	details.
> > + * @tx_can_msg_is_fd: false: all messages in @tx_urb are non-FD CAN,
> > + *	true: all messages in @tx_urb are CAN-FD. Rationale: ES58X FD
> > + *	devices do not allow to mix standard and FD CAN in one single
> > + *	bulk transmission.
> > + * @tx_can_msg_cnt: Number of messages in @tx_urb.
> > + * @err_passive_before_rtx_success: The ES58X device might enter in a
> > + *	state in which it keeps alternating between error passive
> > + *	and active state. This counter keeps track of the number of
> > + *	error passive and if it gets bigger than
> > + *	ES58X_CONSECUTIVE_ERR_PASSIVE_MAX, es58x_rx_err_msg() will
> > + *	force the status to bus-off.
> 
> Is this a bug or a feature?

This is a bug of the device.

Rationale: According to ISO 11898-1, paragraph 12.1.4.2 "Error
counting", the two only possible scenarios to decrements the error
counter are "After the successful transmission of a frame" (paragraph
g) and "After the successful reception of a frame" (paragraph h).

Here, the device switch from error passive state to error active state
without any successful Tx or Rx of a frame. This means that the error
counter does not behave as stipulated in the ISO.

When the issue occurs, the only solution would be to set down the
network. Forcing the bus off allows at least the user to recover (with
restart or restart-ms).

For information, this issue was only witnessed when the device is
trying to send frames on a bus which is already at 100% load.

Example to reproduce: have can0 and can1 on the same bus and do:
cangen -g0 can0
cangen -g0 can1

Note: development team of the device's firmware was informed of this
issue and will consider how to fix it.

> > +#define ES58X_SIZEOF_ES58X_DEVICE(es58x_dev_param)			\
> > +	(offsetof(struct es58x_device, rx_cmd_buf) +			\
> > +		(es58x_dev_param)->rx_urb_cmd_max_len)
> 
> can this be made a static inline?

Yes. Will be fixed in v4.

> > + * Must be a macro in order to retrieve the actual size using
> > + * sizeof(). Can be use with any of the messages which have a fixed
> > + * length. Check for an exact match of the size.
> 
> You can provide an outer macro that does the sizeof() and then calls the a
> normal (static inline) function to do the actual work. Applied to the next 3 macros.

OK. Will be fixed in v4.

> > +#define ES58X_SIZEOF_URB_CMD(es58x_urb_cmd_type, msg_field)		\
> > +	(offsetof(es58x_urb_cmd_type, raw_msg)				\
> > +		+ sizeof_field(es58x_urb_cmd_type, msg_field)		\
> > +		+ sizeof_field(es58x_urb_cmd_type,			\
> > +			reserved_for_crc16_do_not_use))
> 
> static inline?

Sorry but this one can not be converted into a static inline: the
first argument is a type (that will become the first argument of
offsetof() and sizeof_field()).


One more time, thank you for your time and your review!

Yours sincerely,
Vincent Mailhol
