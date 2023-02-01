Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A133E679FC3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjAXRHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjAXRG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:26 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8379C93E1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id x21-20020a056830245500b006865ccca77aso9575720otr.11
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngm4dAzfYfXIR5UGuajtDNkVB/F4zDdqRHCMLAhB8MM=;
        b=pj8N68D8jMq9VAuFdDOL6egLRsPIVqyX8rmzCyeOttilM0t2zmb+t+FNw4xNJH33NJ
         +4Ehk5+QWj63VNX5WGg+e1OvKkilEGdWPbFdcp3RzNTUxLvWhWYBnTksFG9i5WEMMMAV
         VBbE84jc8tnrKbgUSwubhcglkKor0ECk+Vy33OcLxtdUhR1IBlI/xU5fRAm1BTU7K2gf
         uJcStMSY1wQAMVw6I2rGrbfni310RG414VY2LPyDSjm1mrggW2Yqq+EAQVuhpqcvSOzs
         d4qQYZJK6q1J0sJjqbKKWtJjip/dX4/jgqWUXwVwMDai5F3dk/VJpkX3kfMyH2h9vfCA
         822A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngm4dAzfYfXIR5UGuajtDNkVB/F4zDdqRHCMLAhB8MM=;
        b=WT6y9CB0xf9DJurCQx1CNaWP8uwwR7NvwKF1sLR9+QcEXlZfyJL/8x6wOu7C+O+acY
         VaPk1zJfCS3QMmT/xEz8rWxGrzh6NRZi7grb/2mN4XKfuBieIBF+DZh8DFX/CcW0ZVcR
         GurFFP/T+ihNpV490r2hehlJIF3i9+Lm8u/RgwLRMwEMJQ0/LD/7BO+0GvAVKfy5Sp2F
         YzGZQ1/A7x+c7h98kAcGcMmXYGBIEze8YMV3yBl/roWD1EP9LlSB/FRsTh+Pm5Fbaz2f
         rUaYcZcWKhd2MpFh6+ICpfs4rTKJ2gtMAHBxl5SC1l6q4+QZ9DxbIx4m6qSIgSxewLLC
         uLPg==
X-Gm-Message-State: AFqh2kpBswIImrFPYwJeKD+mhqZOzvA+JxhRzDatdQ2h9+3cLi3LewiM
        50xsMr9SY5BoiXqNWYR3JzrekQi4yBPxcOF3
X-Google-Smtp-Source: AMrXdXsaRcYSFe4ReqQPI4OmPdZeeH/nA8kUIGie/jcVuEm+rToMMYQwHchLim6JDx/S0TKHjiex5w==
X-Received: by 2002:a9d:7386:0:b0:670:62c6:56b5 with SMTP id j6-20020a9d7386000000b0067062c656b5mr13613880otk.31.1674579936406;
        Tue, 24 Jan 2023 09:05:36 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:35 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 19/20] p4tc: add dynamic action commands
Date:   Tue, 24 Jan 2023 12:05:09 -0500
Message-Id: <20230124170510.316970-19-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this initial patch, we introduce dynamic action commands which will be
used by dynamic action in P4TC.

The are 8 operations: set, act, print and branching

================================SET================================

The set operation allows us to assign values to objects. The assignee
operand("A") can be metadata, header field, table key, dev or register.
Whilst the assignor operand("B") can be metadata, header field, table key,
register, constant, dev, param or result. We'll describe each of these operand
types further down the commit message.

The set command has the following syntax:

set A B

Operand A's size must be bigger or equal to operand B's size.

Here are some examples of setting metadata to constants:

Create an action that sets kernel skbmark to decimal 1234
 tc p4template create action/myprog/test actid 1 \
 cmd set metadata.kernel.skbmark constant.bit32.1234

set kernel tcindex to 0x5678
 tc p4template create action/myprog/test actid 1 \
 cmd metadata.kernel.tcindex constant.bit32.0x5678

Note that we may specify constants in decimal or hexadecimal format.

Here are some examples of setting metadata to metadata:

Create an action that sets skb->hash to skb->mark
 tc p4template create action/myprog/test actid 1 \
 cmd set metadata.kernel.skbhash metadata.kernel.skbmark

Create an action that sets skb->ifindex to skb->iif
 tc p4template create action/myprog/test actid 1 \
 cmd set metadata.kernel.ifindex metadata.kernel.iif

We can also use user defined metadata in set operations.

For example, if we define the following user metadata

tc p4template create metadata/myprog/mymd type bit32

We could create an action to set its value to skbmark, for example

tc p4template create action/myprog/test actid 1 \
cmd set metadata.myprog.mymd metadata.kernel.skbmark

Note that the way to reference user metadata (from iproute2 perspective)
is equivalent to the way we reference kernel metadata. That is:

METADATA.PIPELINE_NAME.METADATA_NAME

All kernel metadata is stored inside a special pipeline called "kernel".

We can also use bit slices in set operations. For example,
if one wanted to create an action to assign the first 16 bits of user metadata
known as "md" to kernel metadata tcindex, one would right the following:

tc p4template create action/myprog/test actid 1 \
cmd set metadata.myprog.tcindex metadata.kernel.md[0-15]

If we wanted to write the last 16 bits of user metadata "mymd" to kernel
metadata tcindex, we'd issue the following command:

tc p4template create action/myprog/test actid 1 \
cmd set metadata.myprog.tcindex metadata.kernel.md[16-31]

of course one could create multiple sets in one action as such:

 tc p4template create action/myprog/swap_ether actid 1 \
  cmd set metadata.myprog.temp hdrfield.myprog.parser1.ethernet.dstAddr   \
  cmd set hdrfield.myprog.parser1.ethernet.dstAddr hdrfield.myprog.parser1.ethernet.srcAddr \
  cmd set hdrfield.myprog.parser1.ethernet.srcAddr  metadata.myprog.temp

================================ACT================================

The act operation is used to call other actions from dynamic action
commands. Note: we can invoke either kernel native actions, such as gact and
mirred, etc or pipeline defined dynamic actions.

There are two ways to use the act command.
- Create an instance of an action and then calling this specific instance
- Specify the action parameters directly in the act command.

__Method One__

The basic syntax for the first option is:

act PIPELINE_NAME.ACTION_NAME.INDEX

Where PIPELINE_NAME could be a user created pipeline or the native
"kernel" pipeline. For example, if we wanted to call an instance of a mirred
action that mirrors a packet to egress on a specific interface (eth0) then
first we create an instance of the action kind an assign it an index as
follows:

tc actions add action mirred egress mirror dev eth0 index 1

After that, we can then use it on a command by indicating the appropriate
action name and index.

tc p4template create action/myprog/test actid 1 \
cmd act kernel.mirred.1

Note that we use "kernel" as the pipeline name. That's because mirred is
a native kernel action. We could also call pipeline specific action from
a dynamic action's commands, so for example, if we created the
following action template:

We can do the same thing but with user created actions, we could do the
following:

tc p4template create action/myprog/test actid 1 param param1 type bit32

Add an instance of it:

tc actions add action myprog/test param param1 type bit32 22 index 1

We could call it using the following command:

tc p4template create action/myprog/test actid 12 \
cmd act myprog.test.1

__Method Two__

The syntax for the second method is: act ACTION_NAME PARAMS
The second method can only be applied to user defined actions
and allows us to invoke action and passing parameter directly in the
invocation.

So the above example from method1 would turn into the following:

tc p4template create action/myprog/test actid 12 \
cmd act myprog.test constant.bit32.22

================================BRANCHING================================

We have several branch commands: beq (branch-equal), bne (branch-not-equal),
bgt (branch-greater-then), blt (branch-less-then), bge (branch-greater-then),
ble (branch-less-equal)

The basic syntax for branching instructions is:

<compare-operation> <A> <B> <then-clause> / <else-clause>

Where compare-operation could be beq, bne, bg1, blt, bge and ble.

A is one of: header field, metadata, key or result field (like
result.hit or result.miss).
B is one of: a constant, header field or metadata

A and B don't need to be the same size and type as long as B's size is
smaller or equal to A's size.
Note, inherently this means A and B cant both be constants.

Let's take a look at some examples:

tc p4template create action/myprog/test actid 1 \
 cmd beq metadata.kernel.skbmark constant.u32.4 control pipe / jump 1 \
 cmd set metadata.kernel.skbmark constant.u32.123 control ok \
 cmd set metadata.kernel.skbidf constant.bit1.0

The above action executes the equivalent of the following pseudo code:
 if (metadata.kernel.skbmark == 4) then
    metadata.kernel.skbmark = 123
 else
    metadata.kernel.skbidf = 0
 endif

Here is another example, now with bne:

tc p4template create action/myprog/test actid 1 \
cmd bne  metadata.kernel.skbmark constant.u32.4 control pipe / jump else \
cmd set metadata.kernel.skbmark constant.u32.123 \
cmd jump endif \
cmd label else \
cmd set metadata.kernel.skbidf constant.bit1.0 \
cmd label endif

Note in this example we use "labels". These are a more user-friendly
alternative to jumps with numbers, but basically what example action
above does is equivalent of the following pseudo code:

 if (metadata.kernel.skbmark != 4) then
    metadata.kernel.skbmark = 123
 else
    metadata.kernel.skbidf = 0
 endif

This example is basically the logical oposite of the previous one.

================================PRINT================================

The print operation allows us to print the value of operands for
debugging purposes.

The syntax for the print instruction is the following:

PRINT [PREFIX] [ACTUAL_PREFIX] operA

Where operA could be a header field, metadata, key, result, register or
action param.
The PREFIX and ACTUAL_PREFIX fields are optional and could contain a prefix
string that will be printed before operA's value.

Let's first see an example that doesn't use prefix:

sudo tc p4template create action/myprog/test actid 1 \
 cmd print metadata.kernel.skbmark \
 cmd set metadata.kernel.skbmark constant.u32.123 \
 cmd print metadata.kernel.skbmark

Assuming skb->mark was initially 0, this will print:

kernel.skbmark 0
kernel.skbmark 123

If we wanted to add prefixes to those commands, we could do the following:

sudo tc p4template create action/myprog/test actid 1 \
 cmd print prefix before metadata.kernel.skbmark \
 cmd set metadata.kernel.skbmark constant.u32.123 \
 cmd print prefix after metadata.kernel.skbmark

This will print:

before kernel.skbmark 0
after kernel.skbmark 123

================================PLUS================================

The plus command is used to add two operands
The basic syntax for the plus command is:

cmd plus operA operB operC

The command will add operands operB and operC and store the result in
operC. That is: operA = operB + operC

operA can be one of: metadatum, header field.
operB and operC can be one of: constant, metadatum,  key, header field
or param.

The following example will add metadatum mymd from pipeline myprog and
constant 16 and store the result in metadatum mymd2 of pipeline myprog:

tc p4template create action/myprog/myfunc \
   cmd plus metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16

================================SUB================================

The sub command is used to subtract two operands
The basic syntax for the sub command is:

cmd sub operA operB operC

The command will subtract operands operB and operC and store the result in
operC. That is: operA = operB - operC

operA can be one of: metadatum, header field.
operB and operC can be one of: constant, metadatum,  key, header field
or param.

The following example will subtract metadatum mymd from pipeline myprog
and constant 16 and store the result in metadatum mymd2 of pipeline
myprog:

tc p4template create action/myprog/myfunc \
   cmd sub metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16

================================CONCAT================================

The concat command is used to concat upto 8 operands and save the result to
a lvalue.
The basic syntax for the sub command is:

cmd concat operA operB operC [..]

The command will concat operands operB and operC and optionally 6 more
store the result in operC.

It goes without saying that operA's size must be greater or equal to
the sum of (operB's size + operC's size .... operI's size)

operA can be one of: metadatum, a key, a header field.
operB .. operI can only be a constant, a metadatum, a key, a header field
or a param.

The following example will concat metadatum mymd from pipeline myprog
with header field tcp.dport and store the result in metadatum mymd2 of
pipeline myprog:

tc p4template create action/myprog/myfunc \
  cmd concat \
  metadata.myprog.mymd2 metadata.myprog.mymd hdrfield.myprog.myparser.tcp.dport

================================BAND================================

The band command is used to perform a binary AND operation between two
operands. The basic syntax for the band command is:

cmd band operA operB operC

The command will perform the "operB AND operC" and store the result in
operC. That is: operA = operB & operC

operA can be one of: metadatum, header field.
operB and operC can be one of: constant, metadatum,  key, header field
or param.

The following example will perform an AND operation of constant 16 and
mymd metadata and store the result in metadatum mymd2 of pipeline myprog:

tc p4template create action/myprog/myfunc \
   cmd band metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16

================================BOR================================

The bor command is used to perform an binary OR operation between two
operands. The basic syntax for the bor command is:

cmd bor operA operB operC

The command will perform the "operB OR operC" and store the result in
operC. That is: operA = operB | operC

operA can be one of: metadatum, header field.
operB and operC can be one of: constant, metadatum,  key, header field
or param.

The following example will perform an OR operation of constant 16 and
mymd metadata and store the result in metadatum mymd2 of pipeline myprog:

tc p4template create action/myprog/myfunc \
   cmd bor metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16

================================BXOR================================

The bxor command is used to perform an binary XOR operation between two
operands. The basic syntax for the bxor command is:

cmd bxor operA operB operC

The command will perform the "operB XOR operC" and store the result in
operC. That is: operA = operB ^ operC

operA can be one of: metadatum, header field.
operB and operC can be one of: constant, metadatum,  key, header field
or param.

The following example will perform a XOR operation of constant 16 and
mymd metadata and store the result in metadatum mymd2 of pipeline myprog:

tc p4template create action/myprog/myfunc \
   cmd bxor metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16

===============================SND PORT EGRESS===============================

The send_port_egress command sends the received packet to a specific
network interface device. The syntax of the commands is:

cmd send_port_egress operA

operA must be of type dev, that is, a network interface device, which
exists and is up. The following example uses the send_port_egress to send
a packet to port eth0. Note that no other action can run after send_port_egress.

tc p4template create action/myprog/myfunc \
   cmd send_port_egress dev.eth0

===============================MIRPORTEGRESS===============================

The mirror_port_egress command mirror the received packet to a specific
network interface device. The syntax of the commands is:

cmd send_port_egress operA

operA must be of type dev, that is, a network interface device, which
exists and is up. The following example uses the mirror_port_egress to mirror
a packet to port eth0. Note that the semantic of mirror here is means that
we are cloning the packet and sending it to the specified network
interface. This command won't edit or change the course of the original
packet.

tc p4template create action/myprog/myfunc \
   cmd mirror_port_egress dev.eth0

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Co-developed-by: Evangelos Haleplidis <ehalep@mojatatu.com>
Signed-off-by: Evangelos Haleplidis <ehalep@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h           |   68 +
 include/uapi/linux/p4tc.h    |  123 ++
 net/sched/p4tc/Makefile      |    2 +-
 net/sched/p4tc/p4tc_action.c |   89 +-
 net/sched/p4tc/p4tc_cmds.c   | 3492 ++++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_meta.c   |   65 +
 6 files changed, 3835 insertions(+), 4 deletions(-)
 create mode 100644 net/sched/p4tc/p4tc_cmds.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index d9267b798..164cb3c5d 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -594,4 +594,72 @@ void tcf_register_put_rcu(struct rcu_head *head);
 #define to_table(t) ((struct p4tc_table *)t)
 #define to_register(t) ((struct p4tc_register *)t)
 
+/* P4TC COMMANDS */
+int p4tc_cmds_parse(struct net *net, struct p4tc_act *act, struct nlattr *nla,
+		    bool ovr, struct netlink_ext_ack *extack);
+int p4tc_cmds_copy(struct p4tc_act *act, struct list_head *new_cmd_operations,
+		   bool delete_old, struct netlink_ext_ack *extack);
+
+int p4tc_cmds_fillup(struct sk_buff *skb, struct list_head *meta_ops);
+void p4tc_cmds_release_ope_list(struct net *net, struct list_head *entries,
+				bool called_from_template);
+struct p4tc_cmd_operand;
+int p4tc_cmds_fill_operand(struct sk_buff *skb, struct p4tc_cmd_operand *kopnd);
+
+struct p4tc_cmd_operate {
+	struct list_head cmd_operations;
+	struct list_head operands_list;
+	struct p4tc_cmd_s *cmd;
+	char *label1;
+	char *label2;
+	u32 num_opnds;
+	u32 ctl1;
+	u32 ctl2;
+	u16 op_id;		/* P4TC_CMD_OP_XXX */
+	u32 cmd_offset;
+	u8 op_flags;
+	u8 op_cnt;
+};
+
+struct tcf_p4act;
+struct p4tc_cmd_operand {
+	struct list_head oper_list_node;
+	void *(*fetch)(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+		       struct tcf_p4act *cmd, struct tcf_result *res);
+	struct p4tc_type *oper_datatype; /* what is stored in path_or_value - P4T_XXX */
+	struct p4tc_type_mask_shift *oper_mask_shift;
+	struct tc_action *action;
+	void *path_or_value;
+	void *path_or_value_extra;
+	void *print_prefix;
+	void *priv;
+	u64 immedv_large[BITS_TO_U64(P4T_MAX_BITSZ)];
+	u32 immedv;		/* one of: immediate value, metadata id, action id */
+	u32 immedv2;		/* one of: action instance */
+	u32 path_or_value_sz;
+	u32 path_or_value_extra_sz;
+	u32 print_prefix_sz;
+	u32 immedv_large_sz;
+	u32 pipeid;		/* 0 for kernel */
+	u8 oper_type;		/* P4TC_CMD_OPER_XXX */
+	u8 oper_cbitsize;	/* based on P4T_XXX container size */
+	u8 oper_bitsize;	/* diff between bitend - oper_bitend */
+	u8 oper_bitstart;
+	u8 oper_bitend;
+	u8 oper_flags;		/* TBA: DATA_IS_IMMEDIATE */
+};
+
+struct p4tc_cmd_s {
+	int cmdid;
+	u32 num_opnds;
+	int (*validate_operands)(struct net *net, struct p4tc_act *act,
+				 struct p4tc_cmd_operate *ope, u32 cmd_num_opns,
+				 struct netlink_ext_ack *extack);
+	void (*free_operation)(struct net *net, struct p4tc_cmd_operate *op,
+			       bool called_for_instance,
+			       struct netlink_ext_ack *extack);
+	int (*run)(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+		   struct tcf_p4act *cmd, struct tcf_result *res);
+};
+
 #endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 0c5f2943e..e80f93276 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -384,4 +384,127 @@ enum {
 #define P4TC_RTA(r) \
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
 
+/* P4TC COMMANDS */
+
+/* Operations */
+enum {
+	P4TC_CMD_OP_UNSPEC,
+	P4TC_CMD_OP_SET,
+	P4TC_CMD_OP_ACT,
+	P4TC_CMD_OP_BEQ,
+	P4TC_CMD_OP_BNE,
+	P4TC_CMD_OP_BLT,
+	P4TC_CMD_OP_BLE,
+	P4TC_CMD_OP_BGT,
+	P4TC_CMD_OP_BGE,
+	P4TC_CMD_OP_PLUS,
+	P4TC_CMD_OP_PRINT,
+	P4TC_CMD_OP_TBLAPP,
+	P4TC_CMD_OP_SNDPORTEGR,
+	P4TC_CMD_OP_MIRPORTEGR,
+	P4TC_CMD_OP_SUB,
+	P4TC_CMD_OP_CONCAT,
+	P4TC_CMD_OP_BAND,
+	P4TC_CMD_OP_BOR,
+	P4TC_CMD_OP_BXOR,
+	P4TC_CMD_OP_LABEL,
+	P4TC_CMD_OP_JUMP,
+	__P4TC_CMD_OP_MAX
+};
+#define P4TC_CMD_OP_MAX (__P4TC_CMD_OP_MAX - 1)
+
+#define P4TC_CMD_OPERS_MAX 9
+
+/* single operation within P4TC_ACT_CMDS_LIST */
+enum {
+	P4TC_CMD_UNSPEC,
+	P4TC_CMD_OPERATION,	/*struct p4tc_u_operate */
+	P4TC_CMD_OPER_LIST,    /*nested P4TC_CMD_OPER_XXX list */
+	P4TC_CMD_OPER_LABEL1,
+	P4TC_CMD_OPER_LABEL2,
+	__P4TC_CMD_OPER_MAX
+};
+#define P4TC_CMD_OPER_MAX (__P4TC_CMD_OPER_MAX - 1)
+
+enum {
+	P4TC_CMD_OPER_A,
+	P4TC_CMD_OPER_B,
+	P4TC_CMD_OPER_C,
+	P4TC_CMD_OPER_D,
+	P4TC_CMD_OPER_E,
+	P4TC_CMD_OPER_F,
+	P4TC_CMD_OPER_G,
+	P4TC_CMD_OPER_H,
+	P4TC_CMD_OPER_I,
+};
+
+#define P4TC_CMDS_RESULTS_HIT 1
+#define P4TC_CMDS_RESULTS_MISS 2
+
+/* P4TC_CMD_OPERATION */
+struct p4tc_u_operate {
+	__u16 op_type;		/* P4TC_CMD_OP_XXX */
+	__u8 op_flags;
+	__u8 op_UNUSED;
+	__u32 op_ctl1;
+	__u32 op_ctl2;
+};
+
+/* Nested P4TC_CMD_OPER_XXX */
+enum {
+	P4TC_CMD_OPND_UNSPEC,
+	P4TC_CMD_OPND_INFO,
+	P4TC_CMD_OPND_PATH,
+	P4TC_CMD_OPND_PATH_EXTRA,
+	P4TC_CMD_OPND_LARGE_CONSTANT,
+	P4TC_CMD_OPND_PREFIX,
+	__P4TC_CMD_OPND_MAX
+};
+#define P4TC_CMD_OPND_MAX (__P4TC_CMD_OPND_MAX - 1)
+
+/* operand types */
+enum {
+	P4TC_OPER_UNSPEC,
+	P4TC_OPER_CONST,
+	P4TC_OPER_META,
+	P4TC_OPER_ACTID,
+	P4TC_OPER_TBL,
+	P4TC_OPER_KEY,
+	P4TC_OPER_RES,
+	P4TC_OPER_HDRFIELD,
+	P4TC_OPER_PARAM,
+	P4TC_OPER_DEV,
+	P4TC_OPER_REG,
+	P4TC_OPER_LABEL,
+	__P4TC_OPER_MAX
+};
+#define P4TC_OPER_MAX (__P4TC_OPER_MAX - 1)
+
+#define P4TC_CMD_MAX_OPER_PATH_LEN 32
+
+/* P4TC_CMD_OPER_INFO operand*/
+struct p4tc_u_operand {
+	__u32 immedv;		/* immediate value */
+	__u32 immedv2;
+	__u32 pipeid;		/* 0 for kernel-global */
+	__u8 oper_type;		/* P4TC_OPER_XXX */
+	__u8 oper_datatype;	/* T_XXX */
+	__u8 oper_cbitsize;	/* Size of container, u8 = 8, etc
+				 * Useful for a type that is not atomic
+				 */
+	__u8 oper_startbit;
+	__u8 oper_endbit;
+	__u8 oper_flags;
+};
+
+/* operand flags */
+#define DATA_IS_IMMEDIATE (BIT(0)) /* data is held as immediate value */
+#define DATA_IS_RAW (BIT(1))	 /* bitXX datatype, not intepreted by kernel */
+#define DATA_IS_SLICE (BIT(2))	 /* bitslice in a container, not intepreted
+				  * by kernel
+				  */
+#define DATA_USES_ROOT_PIPE (BIT(3))
+#define DATA_HAS_TYPE_INFO (BIT(4))
+#define DATA_IS_READ_ONLY (BIT(5))
+
 #endif
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index b35ced1e3..396fcd249 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -2,4 +2,4 @@
 
 obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
 	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
-	p4tc_tbl_api.o p4tc_register.o
+	p4tc_tbl_api.o p4tc_register.o p4tc_cmds.o
diff --git a/net/sched/p4tc/p4tc_action.c b/net/sched/p4tc/p4tc_action.c
index f47b42bbe..f40acdc5a 100644
--- a/net/sched/p4tc/p4tc_action.c
+++ b/net/sched/p4tc/p4tc_action.c
@@ -147,7 +147,7 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
 {
 	struct tcf_p4act_params *params_old;
 	struct tcf_p4act *p;
-	int err = 0;
+	int err;
 
 	p = to_p4act(*a);
 
@@ -156,6 +156,14 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
 
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 
+	err = p4tc_cmds_copy(act, &p->cmd_operations, exists, extack);
+	if (err < 0) {
+		if (exists)
+			spin_unlock_bh(&p->tcf_lock);
+
+		return err;
+	}
+
 	params_old = rcu_replace_pointer(p->params, params, 1);
 	if (exists)
 		spin_unlock_bh(&p->tcf_lock);
@@ -358,9 +366,15 @@ static int dev_dump_param_value(struct sk_buff *skb,
 
 	nest = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
 	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
+		struct p4tc_cmd_operand *kopnd;
 		struct nlattr *nla_opnd;
 
 		nla_opnd = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE_OPND);
+		kopnd = param->value;
+		if (p4tc_cmds_fill_operand(skb, kopnd) < 0) {
+			ret = -1;
+			goto out_nla_cancel;
+		}
 		nla_nest_end(skb, nla_opnd);
 	} else {
 		const u32 *ifindex = param->value;
@@ -557,10 +571,48 @@ static int tcf_p4_dyna_act(struct sk_buff *skb, const struct tc_action *a,
 {
 	struct tcf_p4act *dynact = to_p4act(a);
 	int ret = 0;
+	int jmp_cnt = 0;
+	struct p4tc_cmd_operate *op;
 
 	tcf_lastuse_update(&dynact->tcf_tm);
 	tcf_action_update_bstats(&dynact->common, skb);
 
+	/* We only need this lock because the operand's that are action
+	 * parameters will be assigned at run-time, and thus will cause a write
+	 * operation in the data path. If we had this structure as per-cpu, we'd
+	 * possibly be able to get rid of this lock.
+	 */
+	lockdep_off();
+	spin_lock(&dynact->tcf_lock);
+	list_for_each_entry(op, &dynact->cmd_operations, cmd_operations) {
+		if (jmp_cnt-- > 0)
+			continue;
+
+		if (op->op_id == P4TC_CMD_OP_LABEL) {
+			ret = TC_ACT_PIPE;
+			continue;
+		}
+
+		ret = op->cmd->run(skb, op, dynact, res);
+		if (TC_ACT_EXT_CMP(ret, TC_ACT_JUMP)) {
+			jmp_cnt = ret & TC_ACT_EXT_VAL_MASK;
+			continue;
+		} else if (ret != TC_ACT_PIPE) {
+			break;
+		}
+	}
+	spin_unlock(&dynact->tcf_lock);
+	lockdep_on();
+
+	if (ret == TC_ACT_SHOT)
+		tcf_action_inc_drop_qstats(&dynact->common);
+
+	if (ret == TC_ACT_STOLEN || ret == TC_ACT_TRAP)
+		ret = TC_ACT_CONSUMED;
+
+	if (ret == TC_ACT_OK)
+		ret = dynact->tcf_action;
+
 	return ret;
 }
 
@@ -589,6 +641,8 @@ static int tcf_p4_dyna_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	if (p4tc_cmds_fillup(skb, &dynact->cmd_operations))
+		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
 	if (nla_put_string(skb, P4TC_ACT_NAME, a->ops->kind))
@@ -688,6 +742,7 @@ static void tcf_p4_dyna_cleanup(struct tc_action *a)
 		refcount_dec(&ops->dyn_ref);
 
 	spin_lock_bh(&m->tcf_lock);
+	p4tc_cmds_release_ope_list(NULL, &m->cmd_operations, false);
 	if (params)
 		call_rcu(&params->rcu, tcf_p4_act_params_destroy_rcu);
 	spin_unlock_bh(&m->tcf_lock);
@@ -702,9 +757,13 @@ int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
 
 	nla_value = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
 	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
+		struct p4tc_cmd_operand *kopnd;
 		struct nlattr *nla_opnd;
 
 		nla_opnd = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE_OPND);
+		kopnd = param->value;
+		if (p4tc_cmds_fill_operand(skb, kopnd) < 0)
+			goto out_nlmsg_trim;
 		nla_nest_end(skb, nla_opnd);
 	} else {
 		if (nla_put(skb, P4TC_ACT_PARAMS_VALUE_RAW, bytesz,
@@ -1279,6 +1338,8 @@ static int __tcf_act_put(struct net *net, struct p4tc_pipeline *pipeline,
 		kfree(act_param);
 	}
 
+	p4tc_cmds_release_ope_list(net, &act->cmd_operations, true);
+
 	ret = __tcf_unregister_action(&act->ops);
 	if (ret < 0) {
 		NL_SET_ERR_MSG(extack,
@@ -1352,6 +1413,8 @@ static int _tcf_act_fill_nlmsg(struct net *net, struct sk_buff *skb,
 	nla_nest_end(skb, parms);
 
 	cmds = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	if (p4tc_cmds_fillup(skb, &act->cmd_operations))
+		goto out_nlmsg_trim;
 	nla_nest_end(skb, cmds);
 
 	nla_nest_end(skb, nest);
@@ -1606,13 +1669,19 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 
 	INIT_LIST_HEAD(&act->cmd_operations);
 	act->pipeline = pipeline;
+	if (tb[P4TC_ACT_CMDS_LIST]) {
+		ret = p4tc_cmds_parse(net, act, tb[P4TC_ACT_CMDS_LIST], false,
+				      extack);
+		if (ret < 0)
+			goto uninit;
+	}
 
 	pipeline->num_created_acts++;
 
 	ret = determine_act_topological_order(pipeline, true);
 	if (ret < 0) {
 		pipeline->num_created_acts--;
-		goto uninit;
+		goto release_cmds;
 	}
 
 	act->common.p_id = pipeline->common.p_id;
@@ -1626,6 +1695,10 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 
 	return act;
 
+release_cmds:
+	if (tb[P4TC_ACT_CMDS_LIST])
+		p4tc_cmds_release_ope_list(net, &act->cmd_operations, false);
+
 uninit:
 	p4_put_many_params(&act->params_idr, params, num_params);
 	idr_destroy(&act->params_idr);
@@ -1704,14 +1777,22 @@ static struct p4tc_act *tcf_act_update(struct net *net, struct nlattr **tb,
 	}
 
 	if (tb[P4TC_ACT_CMDS_LIST]) {
-		ret = determine_act_topological_order(pipeline, true);
+		ret = p4tc_cmds_parse(net, act, tb[P4TC_ACT_CMDS_LIST], true,
+				      extack);
 		if (ret < 0)
 			goto params_del;
+
+		ret = determine_act_topological_order(pipeline, true);
+		if (ret < 0)
+			goto release_cmds;
 	}
 
 	p4tc_params_replace_many(&act->params_idr, params, num_params);
 	return act;
 
+release_cmds:
+	p4tc_cmds_release_ope_list(net, &act->cmd_operations, false);
+
 params_del:
 	p4_put_many_params(&act->params_idr, params, num_params);
 
@@ -1799,6 +1880,8 @@ static int tcf_act_dump_1(struct sk_buff *skb,
 		goto out_nlmsg_trim;
 
 	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	if (p4tc_cmds_fillup(skb, &act->cmd_operations))
+		goto out_nlmsg_trim;
 	nla_nest_end(skb, nest);
 
 	if (nla_put_u8(skb, P4TC_ACT_ACTIVE, act->active))
diff --git a/net/sched/p4tc/p4tc_cmds.c b/net/sched/p4tc/p4tc_cmds.c
new file mode 100644
index 000000000..85496ee75
--- /dev/null
+++ b/net/sched/p4tc/p4tc_cmds.c
@@ -0,0 +1,3492 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_cmds.c - P4 TC cmds
+ * Copyright (c) 2022, Mojatatu Networks
+ * Copyright (c) 2022, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <net/act_api.h>
+#include <net/net_namespace.h>
+#include <net/netlink.h>
+#include <net/p4tc_types.h>
+#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
+#include <net/p4tc.h>
+
+#include <uapi/linux/p4tc.h>
+
+#define GET_OPA(operands_list)                                    \
+	(list_first_entry(operands_list, struct p4tc_cmd_operand, \
+			  oper_list_node))
+
+#define GET_OPB(operands_list) \
+	(list_next_entry(GET_OPA(operands_list), oper_list_node))
+
+#define GET_OPC(operands_list) \
+	(list_next_entry(GET_OPB(operands_list), oper_list_node))
+
+#define P4TC_FETCH_DECLARE(fname)                                            \
+	static void *(fname)(struct sk_buff *skb, struct p4tc_cmd_operand *op, \
+			     struct tcf_p4act *cmd, struct tcf_result *res)
+
+P4TC_FETCH_DECLARE(p4tc_fetch_metadata);
+P4TC_FETCH_DECLARE(p4tc_fetch_constant);
+P4TC_FETCH_DECLARE(p4tc_fetch_key);
+P4TC_FETCH_DECLARE(p4tc_fetch_table);
+P4TC_FETCH_DECLARE(p4tc_fetch_result);
+P4TC_FETCH_DECLARE(p4tc_fetch_hdrfield);
+P4TC_FETCH_DECLARE(p4tc_fetch_param);
+P4TC_FETCH_DECLARE(p4tc_fetch_dev);
+P4TC_FETCH_DECLARE(p4tc_fetch_reg);
+
+#define P4TC_CMD_DECLARE(fname)                                            \
+	static int fname(struct sk_buff *skb, struct p4tc_cmd_operate *op, \
+			 struct tcf_p4act *cmd, struct tcf_result *res)
+
+P4TC_CMD_DECLARE(p4tc_cmd_SET);
+P4TC_CMD_DECLARE(p4tc_cmd_ACT);
+P4TC_CMD_DECLARE(p4tc_cmd_PRINT);
+P4TC_CMD_DECLARE(p4tc_cmd_TBLAPP);
+P4TC_CMD_DECLARE(p4tc_cmd_SNDPORTEGR);
+P4TC_CMD_DECLARE(p4tc_cmd_MIRPORTEGR);
+P4TC_CMD_DECLARE(p4tc_cmd_PLUS);
+P4TC_CMD_DECLARE(p4tc_cmd_SUB);
+P4TC_CMD_DECLARE(p4tc_cmd_CONCAT);
+P4TC_CMD_DECLARE(p4tc_cmd_BAND);
+P4TC_CMD_DECLARE(p4tc_cmd_BOR);
+P4TC_CMD_DECLARE(p4tc_cmd_BXOR);
+P4TC_CMD_DECLARE(p4tc_cmd_JUMP);
+
+static void kfree_opentry(struct net *net, struct p4tc_cmd_operate *ope,
+			  bool called_from_template)
+{
+	if (!ope)
+		return;
+
+	ope->cmd->free_operation(net, ope, called_from_template, NULL);
+}
+
+static void copy_k2u_operand(struct p4tc_cmd_operand *k,
+			     struct p4tc_u_operand *u)
+{
+	u->pipeid = k->pipeid;
+	u->immedv = k->immedv;
+	u->immedv2 = k->immedv2;
+	u->oper_type = k->oper_type;
+	u->oper_datatype = k->oper_datatype->typeid;
+	u->oper_cbitsize = k->oper_cbitsize;
+	u->oper_startbit = k->oper_bitstart;
+	u->oper_endbit = k->oper_bitend;
+	u->oper_flags = k->oper_flags;
+}
+
+static int copy_u2k_operand(struct p4tc_u_operand *uopnd,
+			    struct p4tc_cmd_operand *kopnd,
+			    struct netlink_ext_ack *extack)
+{
+	struct p4tc_type *type;
+
+	type = p4type_find_byid(uopnd->oper_datatype);
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO && !type) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid operand type");
+		return -EINVAL;
+	}
+
+	kopnd->pipeid = uopnd->pipeid;
+	kopnd->immedv = uopnd->immedv;
+	kopnd->immedv2 = uopnd->immedv2;
+	kopnd->oper_type = uopnd->oper_type;
+	kopnd->oper_datatype = type;
+	kopnd->oper_cbitsize = uopnd->oper_cbitsize;
+	kopnd->oper_bitstart = uopnd->oper_startbit;
+	kopnd->oper_bitend = uopnd->oper_endbit;
+	kopnd->oper_bitsize = 1 + kopnd->oper_bitend - kopnd->oper_bitstart;
+	kopnd->oper_flags = uopnd->oper_flags;
+
+	return 0;
+}
+
+int p4tc_cmds_fill_operand(struct sk_buff *skb, struct p4tc_cmd_operand *kopnd)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_u_operand oper = { 0 };
+	u32 plen;
+
+	copy_k2u_operand(kopnd, &oper);
+	if (nla_put(skb, P4TC_CMD_OPND_INFO, sizeof(struct p4tc_u_operand),
+		    &oper))
+		goto nla_put_failure;
+
+	if (kopnd->path_or_value &&
+	    nla_put_string(skb, P4TC_CMD_OPND_PATH, kopnd->path_or_value))
+		goto nla_put_failure;
+
+	if (kopnd->path_or_value_extra &&
+	    nla_put_string(skb, P4TC_CMD_OPND_PATH_EXTRA,
+			   kopnd->path_or_value_extra))
+		goto nla_put_failure;
+
+	if (kopnd->print_prefix &&
+	    nla_put_string(skb, P4TC_CMD_OPND_PREFIX, kopnd->print_prefix))
+		goto nla_put_failure;
+
+	plen = kopnd->immedv_large_sz;
+
+	if (plen && nla_put(skb, P4TC_CMD_OPND_LARGE_CONSTANT, plen,
+			    kopnd->immedv_large))
+		goto nla_put_failure;
+
+	return skb->len;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int p4tc_cmds_fill_operands_list(struct sk_buff *skb,
+					struct list_head *operands_list)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	int i = 1;
+	struct p4tc_cmd_operand *cursor;
+	struct nlattr *nest_count;
+
+	list_for_each_entry(cursor, operands_list, oper_list_node) {
+		nest_count = nla_nest_start(skb, i);
+
+		if (p4tc_cmds_fill_operand(skb, cursor) < 0)
+			goto nla_put_failure;
+
+		nla_nest_end(skb, nest_count);
+		i++;
+	}
+
+	return skb->len;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+/* under spin lock */
+int p4tc_cmds_fillup(struct sk_buff *skb, struct list_head *cmd_operations)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_u_operate op = {};
+	int i = 1;
+	struct nlattr *nest_op, *nest_opnds;
+	struct p4tc_cmd_operate *entry;
+	int err;
+
+	list_for_each_entry(entry, cmd_operations, cmd_operations) {
+		nest_op = nla_nest_start(skb, i);
+
+		op.op_type = entry->op_id;
+		op.op_flags = entry->op_flags;
+		op.op_ctl1 = entry->ctl1;
+		op.op_ctl2 = entry->ctl2;
+		if (nla_put(skb, P4TC_CMD_OPERATION,
+			    sizeof(struct p4tc_u_operate), &op))
+			goto nla_put_failure;
+
+		if (!list_empty(&entry->operands_list)) {
+			nest_opnds = nla_nest_start(skb, P4TC_CMD_OPER_LIST);
+			err = p4tc_cmds_fill_operands_list(skb,
+							   &entry->operands_list);
+			if (err < 0)
+				goto nla_put_failure;
+			nla_nest_end(skb, nest_opnds);
+		}
+
+		nla_nest_end(skb, nest_op);
+		i++;
+	}
+
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+void p4tc_cmds_release_ope_list(struct net *net, struct list_head *entries,
+				bool called_from_template)
+{
+	struct p4tc_cmd_operate *entry, *e;
+
+	list_for_each_entry_safe(entry, e, entries, cmd_operations) {
+		list_del(&entry->cmd_operations);
+		kfree_opentry(net, entry, called_from_template);
+	}
+}
+
+static void kfree_tmp_oplist(struct net *net, struct p4tc_cmd_operate *oplist[],
+			     bool called_from_template)
+{
+	int i = 0;
+	struct p4tc_cmd_operate *ope;
+
+	for (i = 0; i < P4TC_CMDS_LIST_MAX; i++) {
+		ope = oplist[i];
+		if (!ope)
+			continue;
+
+		kfree_opentry(net, ope, called_from_template);
+	}
+}
+
+static int validate_metadata_operand(struct p4tc_cmd_operand *kopnd,
+				     struct p4tc_type *container_type,
+				     struct netlink_ext_ack *extack)
+{
+	struct p4tc_type_ops *type_ops = container_type->ops;
+	int err;
+
+	if (kopnd->oper_cbitsize < kopnd->oper_bitsize) {
+		NL_SET_ERR_MSG_MOD(extack, "bitsize has to be <= cbitsize\n");
+		return -EINVAL;
+	}
+
+	if (type_ops->validate_p4t) {
+		if (kopnd->oper_type == P4TC_OPER_CONST)
+			if (kopnd->oper_flags & DATA_IS_IMMEDIATE) {
+				err = type_ops->validate_p4t(container_type,
+							     &kopnd->immedv,
+							     kopnd->oper_bitstart,
+							     kopnd->oper_bitend,
+							     extack);
+			} else {
+				err = type_ops->validate_p4t(container_type,
+							     kopnd->immedv_large,
+							     kopnd->oper_bitstart,
+							     kopnd->oper_bitend,
+							     extack);
+			}
+		else
+			err = type_ops->validate_p4t(container_type, NULL,
+						     kopnd->oper_bitstart,
+						     kopnd->oper_bitend,
+						     extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int validate_table_operand(struct p4tc_act *act,
+				  struct p4tc_cmd_operand *kopnd,
+				  struct netlink_ext_ack *extack)
+{
+	struct p4tc_table *table;
+
+	table = tcf_table_get(act->pipeline, (const char *)kopnd->path_or_value,
+			      kopnd->immedv, extack);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	kopnd->priv = table;
+
+	return 0;
+}
+
+static int validate_key_operand(struct p4tc_act *act,
+				struct p4tc_cmd_operand *kopnd,
+				struct netlink_ext_ack *extack)
+{
+	struct p4tc_type *t = kopnd->oper_datatype;
+	struct p4tc_table *table;
+
+	kopnd->pipeid = act->pipeline->common.p_id;
+
+	table = tcf_table_get(act->pipeline, (const char *)kopnd->path_or_value,
+			      kopnd->immedv, extack);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	kopnd->immedv = table->tbl_id;
+
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO) {
+		if (kopnd->oper_bitstart != 0) {
+			NL_SET_ERR_MSG_MOD(extack, "Key bitstart must be zero");
+			return -EINVAL;
+		}
+
+		if (t->typeid != P4T_KEY) {
+			NL_SET_ERR_MSG_MOD(extack, "Key type must be key");
+			return -EINVAL;
+		}
+
+		if (table->tbl_keysz != kopnd->oper_bitsize) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Type size doesn't match table keysz");
+			return -EINVAL;
+		}
+
+		t->bitsz = kopnd->oper_bitsize;
+	} else {
+		t = p4type_find_byid(P4T_KEY);
+		if (!t)
+			return -EINVAL;
+
+		kopnd->oper_bitstart = 0;
+		kopnd->oper_bitend = table->tbl_keysz - 1;
+		kopnd->oper_bitsize = table->tbl_keysz;
+		kopnd->oper_datatype = t;
+	}
+
+	return 0;
+}
+
+static int validate_hdrfield_operand_type(struct p4tc_cmd_operand *kopnd,
+					  struct p4tc_hdrfield *hdrfield,
+					  struct netlink_ext_ack *extack)
+{
+	if (hdrfield->startbit != kopnd->oper_bitstart ||
+	    hdrfield->endbit != kopnd->oper_bitend ||
+	    hdrfield->datatype != kopnd->oper_datatype->typeid) {
+		NL_SET_ERR_MSG_MOD(extack, "Header field type mismatch");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int validate_hdrfield_operand(struct p4tc_act *act,
+				     struct p4tc_cmd_operand *kopnd,
+				     struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield;
+	struct p4tc_parser *parser;
+	struct p4tc_type *typ;
+
+	kopnd->pipeid = act->pipeline->common.p_id;
+
+	parser = tcf_parser_find_byany(act->pipeline,
+				       (const char *)kopnd->path_or_value,
+				       kopnd->immedv, extack);
+	if (IS_ERR(parser))
+		return PTR_ERR(parser);
+	kopnd->immedv = parser->parser_inst_id;
+
+	hdrfield = tcf_hdrfield_get(parser,
+				    (const char *)kopnd->path_or_value_extra,
+				    kopnd->immedv2, extack);
+	if (IS_ERR(hdrfield))
+		return PTR_ERR(hdrfield);
+	kopnd->immedv2 = hdrfield->hdrfield_id;
+
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO) {
+		if (validate_hdrfield_operand_type(kopnd, hdrfield, extack) < 0)
+			return -EINVAL;
+	} else {
+		kopnd->oper_bitstart = hdrfield->startbit;
+		kopnd->oper_bitend = hdrfield->endbit;
+		kopnd->oper_datatype = p4type_find_byid(hdrfield->datatype);
+		kopnd->oper_bitsize = hdrfield->endbit - hdrfield->startbit + 1;
+		kopnd->oper_cbitsize = kopnd->oper_datatype->container_bitsz;
+	}
+	typ = kopnd->oper_datatype;
+	if (typ->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = typ->ops->create_bitops(kopnd->oper_bitsize,
+						     kopnd->oper_bitstart,
+						     kopnd->oper_bitend,
+						     extack);
+		if (IS_ERR(mask_shift))
+			return PTR_ERR(mask_shift);
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	kopnd->priv = hdrfield;
+
+	refcount_inc(&act->pipeline->p_hdrs_used);
+
+	return 0;
+}
+
+struct p4tc_cmd_opnd_priv_dev {
+	struct net_device *dev;
+	netdevice_tracker *tracker;
+};
+
+int validate_dev_operand(struct net *net, struct p4tc_cmd_operand *kopnd,
+			 struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_opnd_priv_dev *priv_dev;
+	struct net_device *dev;
+
+	if (kopnd->oper_datatype->typeid != P4T_DEV) {
+		NL_SET_ERR_MSG_MOD(extack, "dev parameter must be dev");
+		return -EINVAL;
+	}
+
+	if (kopnd->oper_datatype->ops->validate_p4t(kopnd->oper_datatype,
+						    &kopnd->immedv,
+						    kopnd->oper_bitstart,
+						    kopnd->oper_bitend,
+						    extack) < 0) {
+		return -EINVAL;
+	}
+
+	priv_dev = kzalloc(sizeof(*priv_dev), GFP_KERNEL);
+	if (!priv_dev)
+		return -ENOMEM;
+	kopnd->priv = priv_dev;
+
+	dev = dev_get_by_index(net, kopnd->immedv);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid ifindex");
+		return -ENODEV;
+	}
+	priv_dev->dev = dev;
+	netdev_tracker_alloc(dev, priv_dev->tracker, GFP_KERNEL);
+
+	return 0;
+}
+
+static int validate_param_operand(struct p4tc_act *act,
+				  struct p4tc_cmd_operand *kopnd,
+				  struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *param;
+	struct p4tc_type *t;
+
+	param = tcf_param_find_byany(act, (const char *)kopnd->path_or_value,
+				     kopnd->immedv2, extack);
+
+	if (IS_ERR(param))
+		return PTR_ERR(param);
+
+	kopnd->pipeid = act->pipeline->common.p_id;
+	kopnd->immedv = act->a_id;
+	kopnd->immedv2 = param->id;
+
+	t = p4type_find_byid(param->type);
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO) {
+		if (t->typeid != kopnd->oper_datatype->typeid) {
+			NL_SET_ERR_MSG_MOD(extack, "Param type mismatch");
+			return -EINVAL;
+		}
+
+		if (t->bitsz != kopnd->oper_datatype->bitsz) {
+			NL_SET_ERR_MSG_MOD(extack, "Param size mismatch");
+			return -EINVAL;
+		}
+	} else {
+		kopnd->oper_datatype = t;
+		kopnd->oper_bitstart = 0;
+		kopnd->oper_bitend = t->bitsz - 1;
+		kopnd->oper_bitsize = t->bitsz;
+	}
+	kopnd->pipeid = act->pipeline->common.p_id;
+	kopnd->immedv = act->a_id;
+	kopnd->immedv2 = param->id;
+	kopnd->oper_flags |= DATA_IS_READ_ONLY;
+
+	if (kopnd->oper_bitstart != 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Param startbit must be zero");
+		return -EINVAL;
+	}
+
+	if (kopnd->oper_bitstart > kopnd->oper_bitend) {
+		NL_SET_ERR_MSG_MOD(extack, "Param startbit > endbit");
+		return -EINVAL;
+	}
+
+	if (t->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = t->ops->create_bitops(kopnd->oper_bitsize,
+						   kopnd->oper_bitstart,
+						   kopnd->oper_bitend, extack);
+		if (IS_ERR(mask_shift))
+			return PTR_ERR(mask_shift);
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	return 0;
+}
+
+static int validate_res_operand(struct p4tc_cmd_operand *kopnd,
+				struct netlink_ext_ack *extack)
+{
+	if (kopnd->immedv == P4TC_CMDS_RESULTS_HIT ||
+	    kopnd->immedv == P4TC_CMDS_RESULTS_MISS)
+		return 0;
+
+	kopnd->oper_flags |= DATA_IS_READ_ONLY;
+
+	NL_SET_ERR_MSG_MOD(extack, "Invalid result field");
+	return -EINVAL;
+}
+
+static int register_label(struct p4tc_act *act, const char *label,
+			  int cmd_offset, struct netlink_ext_ack *extack)
+{
+	const size_t labelsz = strnlen(label, LABELNAMSIZ) + 1;
+	struct p4tc_label_node *node;
+	void *ptr;
+	int err;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->key.label = kzalloc(labelsz, GFP_KERNEL);
+	if (!(node->key.label)) {
+		err = -ENOMEM;
+		goto free_node;
+	}
+
+	strscpy(node->key.label, label, labelsz);
+	node->key.labelsz = labelsz;
+
+	node->cmd_offset = cmd_offset;
+
+	ptr = rhashtable_insert_slow(act->labels, &node->key, &node->ht_node);
+	if (IS_ERR(ptr)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unable to insert in labels hashtable");
+		err = PTR_ERR(ptr);
+		goto free_label;
+	}
+
+	return 0;
+
+free_label:
+	kfree(node->key.label);
+
+free_node:
+	kfree(node);
+
+	return err;
+}
+
+static int validate_label_operand(struct p4tc_act *act,
+				  struct p4tc_cmd_operate *ope,
+				  struct p4tc_cmd_operand *kopnd,
+				  struct netlink_ext_ack *extack)
+{
+	kopnd->oper_datatype = p4type_find_byid(P4T_U32);
+	return register_label(act, (const char *)kopnd->path_or_value,
+			      ope->cmd_offset, extack);
+}
+
+static int cmd_find_label_offset(struct p4tc_act *act, const char *label,
+				 struct netlink_ext_ack *extack)
+{
+	struct p4tc_label_node *node;
+	struct p4tc_label_key label_key;
+
+	label_key.label = (char *)label;
+	label_key.labelsz = strnlen(label, LABELNAMSIZ) + 1;
+
+	node = rhashtable_lookup(act->labels, &label_key, p4tc_label_ht_params);
+	if (!node) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to find label");
+		return -ENOENT;
+	}
+
+	return node->cmd_offset;
+}
+
+static int validate_reg_operand(struct p4tc_act *act,
+				struct p4tc_cmd_operand *kopnd,
+				struct netlink_ext_ack *extack)
+{
+	struct p4tc_register *reg;
+	struct p4tc_type *t;
+
+	reg = tcf_register_get(act->pipeline,
+			       (const char *)kopnd->path_or_value,
+			       kopnd->immedv, extack);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+	kopnd->pipeid = act->pipeline->common.p_id;
+	kopnd->immedv = reg->reg_id;
+
+	if (kopnd->immedv2 >= reg->reg_num_elems) {
+		NL_SET_ERR_MSG_MOD(extack, "Register index out of bounds");
+		return -EINVAL;
+	}
+
+	t = reg->reg_type;
+	kopnd->oper_datatype = t;
+
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO) {
+		if (reg->reg_type->typeid != kopnd->oper_datatype->typeid) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Invalid register data type");
+			return -EINVAL;
+		}
+
+		if (kopnd->oper_bitstart > kopnd->oper_bitend) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Register startbit > endbit");
+			return -EINVAL;
+		}
+	} else {
+		kopnd->oper_bitstart = 0;
+		kopnd->oper_bitend = t->bitsz - 1;
+		kopnd->oper_bitsize = t->bitsz;
+	}
+
+	if (t->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = t->ops->create_bitops(kopnd->oper_bitsize,
+						   kopnd->oper_bitstart,
+						   kopnd->oper_bitend, extack);
+		if (IS_ERR(mask_shift))
+			return PTR_ERR(mask_shift);
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	/* Should never fail */
+	WARN_ON(!refcount_inc_not_zero(&reg->reg_ref));
+
+	kopnd->priv = reg;
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+create_metadata_bitops(struct p4tc_cmd_operand *kopnd,
+		       struct p4tc_metadata *meta, struct p4tc_type *t,
+		       struct netlink_ext_ack *extack)
+{
+	struct p4tc_type_mask_shift *mask_shift;
+	u8 bitstart, bitend;
+	u32 bitsz;
+
+	if (kopnd->oper_flags & DATA_IS_SLICE) {
+		bitstart = meta->m_startbit + kopnd->oper_bitstart;
+		bitend = meta->m_startbit + kopnd->oper_bitend;
+	} else {
+		bitstart = meta->m_startbit;
+		bitend = meta->m_endbit;
+	}
+	bitsz = bitend - bitstart + 1;
+	mask_shift = t->ops->create_bitops(bitsz, bitstart, bitend, extack);
+	return mask_shift;
+}
+
+static int __validate_metadata_operand(struct net *net, struct p4tc_act *act,
+				       struct p4tc_cmd_operand *kopnd,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_type *container_type;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_metadata *meta;
+	u32 bitsz;
+	int err;
+
+	if (kopnd->oper_flags & DATA_USES_ROOT_PIPE)
+		pipeline = tcf_pipeline_find_byid(net, 0);
+	else
+		pipeline = act->pipeline;
+
+	kopnd->pipeid = pipeline->common.p_id;
+
+	meta = tcf_meta_get(pipeline, (const char *)kopnd->path_or_value,
+			    kopnd->immedv, extack);
+	if (IS_ERR(meta))
+		return PTR_ERR(meta);
+	kopnd->immedv = meta->m_id;
+
+	if (!(kopnd->oper_flags & DATA_IS_SLICE)) {
+		kopnd->oper_bitstart = meta->m_startbit;
+		kopnd->oper_bitend = meta->m_endbit;
+
+		bitsz = meta->m_endbit - meta->m_startbit + 1;
+		kopnd->oper_bitsize = bitsz;
+	} else {
+		bitsz = kopnd->oper_bitend - kopnd->oper_bitstart + 1;
+	}
+
+	if (kopnd->oper_flags & DATA_HAS_TYPE_INFO) {
+		if (meta->m_datatype != kopnd->oper_datatype->typeid) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Invalid metadata data type");
+			return -EINVAL;
+		}
+
+		if (bitsz < kopnd->oper_bitsize) {
+			NL_SET_ERR_MSG_MOD(extack, "Invalid metadata bit size");
+			return -EINVAL;
+		}
+
+		if (kopnd->oper_bitstart > meta->m_endbit) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Invalid metadata slice start bit");
+			return -EINVAL;
+		}
+
+		if (kopnd->oper_bitend > meta->m_endbit) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Invalid metadata slice end bit");
+			return -EINVAL;
+		}
+	} else {
+		kopnd->oper_datatype = p4type_find_byid(meta->m_datatype);
+		kopnd->oper_bitsize = bitsz;
+		kopnd->oper_cbitsize = bitsz;
+	}
+
+	container_type = p4type_find_byid(meta->m_datatype);
+	if (!container_type) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid metadata type");
+		return -EINVAL;
+	}
+
+	err = validate_metadata_operand(kopnd, container_type, extack);
+	if (err < 0)
+		return err;
+
+	if (meta->m_read_only)
+		kopnd->oper_flags |= DATA_IS_READ_ONLY;
+
+	if (container_type->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = create_metadata_bitops(kopnd, meta, container_type,
+						    extack);
+		if (IS_ERR(mask_shift))
+			return -EINVAL;
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	kopnd->priv = meta;
+
+	return 0;
+}
+
+static struct p4tc_type_mask_shift *
+create_constant_bitops(struct p4tc_cmd_operand *kopnd, struct p4tc_type *t,
+		       struct netlink_ext_ack *extack)
+{
+	struct p4tc_type_mask_shift *mask_shift;
+
+	mask_shift = t->ops->create_bitops(t->bitsz, kopnd->oper_bitstart,
+					   kopnd->oper_bitend, extack);
+	return mask_shift;
+}
+
+static int validate_large_operand(struct p4tc_cmd_operand *kopnd,
+				  struct netlink_ext_ack *extack)
+{
+	struct p4tc_type *t = kopnd->oper_datatype;
+	int err = 0;
+
+	err = validate_metadata_operand(kopnd, t, extack);
+	if (err)
+		return err;
+	if (t->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = create_constant_bitops(kopnd, t, extack);
+		if (IS_ERR(mask_shift))
+			return -EINVAL;
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	return 0;
+}
+
+/*Data is constant <=32 bits */
+static int validate_immediate_operand(struct p4tc_cmd_operand *kopnd,
+				      struct netlink_ext_ack *extack)
+{
+	struct p4tc_type *t = kopnd->oper_datatype;
+	int err = 0;
+
+	err = validate_metadata_operand(kopnd, t, extack);
+	if (err)
+		return err;
+	if (t->ops->create_bitops) {
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = create_constant_bitops(kopnd, t, extack);
+		if (IS_ERR(mask_shift))
+			return -EINVAL;
+
+		kopnd->oper_mask_shift = mask_shift;
+	}
+
+	return 0;
+}
+
+static int validate_operand(struct net *net, struct p4tc_act *act,
+			    struct p4tc_cmd_operate *ope,
+			    struct p4tc_cmd_operand *kopnd,
+			    struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	if (!kopnd)
+		return err;
+
+	switch (kopnd->oper_type) {
+	case P4TC_OPER_CONST:
+		if (kopnd->oper_flags & DATA_IS_IMMEDIATE)
+			err = validate_immediate_operand(kopnd, extack);
+		else
+			err = validate_large_operand(kopnd, extack);
+		kopnd->oper_flags |= DATA_IS_READ_ONLY;
+		break;
+	case P4TC_OPER_META:
+		err = __validate_metadata_operand(net, act, kopnd, extack);
+		break;
+	case P4TC_OPER_ACTID:
+		err = 0;
+		break;
+	case P4TC_OPER_TBL:
+		err = validate_table_operand(act, kopnd, extack);
+		break;
+	case P4TC_OPER_KEY:
+		err = validate_key_operand(act, kopnd, extack);
+		break;
+	case P4TC_OPER_RES:
+		err = validate_res_operand(kopnd, extack);
+		break;
+	case P4TC_OPER_HDRFIELD:
+		err = validate_hdrfield_operand(act, kopnd, extack);
+		break;
+	case P4TC_OPER_PARAM:
+		err = validate_param_operand(act, kopnd, extack);
+		break;
+	case P4TC_OPER_DEV:
+		err = validate_dev_operand(net, kopnd, extack);
+		break;
+	case P4TC_OPER_REG:
+		err = validate_reg_operand(act, kopnd, extack);
+		break;
+	case P4TC_OPER_LABEL:
+		err = validate_label_operand(act, ope, kopnd, extack);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown operand type");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static void __free_operand(struct p4tc_cmd_operand *op)
+{
+	if (op->oper_mask_shift)
+		p4t_release(op->oper_mask_shift);
+	kfree(op->path_or_value);
+	kfree(op->path_or_value_extra);
+	kfree(op->print_prefix);
+	kfree(op);
+}
+
+static void _free_operand_template(struct net *net, struct p4tc_cmd_operand *op)
+{
+	switch (op->oper_type) {
+	case P4TC_OPER_META: {
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_metadata *meta;
+
+		pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+		if (pipeline) {
+			meta = tcf_meta_find_byid(pipeline, op->immedv);
+			if (meta)
+				tcf_meta_put_ref(meta);
+		}
+		break;
+	}
+	case P4TC_OPER_ACTID: {
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_act *act;
+
+		if (!(op->oper_flags & DATA_USES_ROOT_PIPE)) {
+			pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+			if (pipeline) {
+				act = tcf_action_find_byid(pipeline,
+							   op->immedv);
+				if (act)
+					tcf_action_put(act);
+			}
+		}
+		kfree(op->priv);
+		break;
+	}
+	case P4TC_OPER_TBL: {
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_table *table;
+
+		pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+		if (pipeline) {
+			table = tcf_table_find_byid(pipeline, op->immedv);
+			if (table)
+				tcf_table_put_ref(table);
+		}
+		break;
+	}
+	case P4TC_OPER_KEY: {
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_table *table;
+
+		pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+		if (pipeline) {
+			table = tcf_table_find_byid(pipeline, op->immedv);
+			if (table)
+				tcf_table_put_ref(table);
+		}
+		break;
+	}
+	case P4TC_OPER_HDRFIELD: {
+		struct p4tc_pipeline *pipeline;
+
+		pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+		/* Should never be NULL */
+		if (pipeline) {
+			struct p4tc_hdrfield *hdrfield;
+			struct p4tc_parser *parser;
+
+			if (refcount_read(&pipeline->p_hdrs_used) > 1)
+				refcount_dec(&pipeline->p_hdrs_used);
+
+			parser = tcf_parser_find_byid(pipeline, op->immedv);
+			if (parser) {
+				hdrfield = tcf_hdrfield_find_byid(parser,
+								  op->immedv2);
+
+				if (hdrfield)
+					if (refcount_read(&hdrfield->hdrfield_ref) > 1)
+						tcf_hdrfield_put_ref(hdrfield);
+			}
+		}
+		break;
+	}
+	case P4TC_OPER_DEV: {
+		struct p4tc_cmd_opnd_priv_dev *priv = op->priv;
+
+		if (priv && priv->dev)
+			netdev_put(priv->dev, priv->tracker);
+		kfree(priv);
+		break;
+	}
+	case P4TC_OPER_REG: {
+		struct p4tc_pipeline *pipeline;
+
+		pipeline = tcf_pipeline_find_byid(net, op->pipeid);
+		/* Should never be NULL */
+		if (pipeline) {
+			struct p4tc_register *reg;
+
+			reg = tcf_register_find_byid(pipeline, op->immedv);
+			if (reg)
+				tcf_register_put_ref(reg);
+		}
+		break;
+	}
+	}
+
+	__free_operand(op);
+}
+
+static void _free_operand_list_instance(struct list_head *operands_list)
+{
+	struct p4tc_cmd_operand *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, operands_list, oper_list_node) {
+		list_del(&op->oper_list_node);
+		__free_operand(op);
+	}
+}
+
+static void _free_operand_list_template(struct net *net,
+					struct list_head *operands_list)
+{
+	struct p4tc_cmd_operand *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, operands_list, oper_list_node) {
+		list_del(&op->oper_list_node);
+		_free_operand_template(net, op);
+	}
+}
+
+static void _free_operation(struct net *net, struct p4tc_cmd_operate *ope,
+			    bool called_from_template,
+			    struct netlink_ext_ack *extack)
+{
+	if (called_from_template)
+		_free_operand_list_template(net, &ope->operands_list);
+	else
+		_free_operand_list_instance(&ope->operands_list);
+
+	kfree(ope->label1);
+	kfree(ope->label2);
+	kfree(ope);
+}
+
+/* XXX: copied from act_api::tcf_free_cookie_rcu - at some point share the code */
+static void _tcf_free_cookie_rcu(struct rcu_head *p)
+{
+	struct tc_cookie *cookie = container_of(p, struct tc_cookie, rcu);
+
+	kfree(cookie->data);
+	kfree(cookie);
+}
+
+/* XXX: copied from act_api::tcf_set_action_cookie - at some point share the code */
+static void _tcf_set_action_cookie(struct tc_cookie __rcu **old_cookie,
+				   struct tc_cookie *new_cookie)
+{
+	struct tc_cookie *old;
+
+	old = xchg((__force struct tc_cookie **)old_cookie, new_cookie);
+	if (old)
+		call_rcu(&old->rcu, _tcf_free_cookie_rcu);
+}
+
+/* XXX: copied from act_api::free_tcf - at some point share the code */
+static void _free_tcf(struct tc_action *p)
+{
+	struct tcf_chain *chain = rcu_dereference_protected(p->goto_chain, 1);
+
+	free_percpu(p->cpu_bstats);
+	free_percpu(p->cpu_bstats_hw);
+	free_percpu(p->cpu_qstats);
+
+	_tcf_set_action_cookie(&p->act_cookie, NULL);
+	if (chain)
+		tcf_chain_put_by_act(chain);
+
+	kfree(p);
+}
+
+#define P4TC_CMD_OPER_ACT_RUNTIME (BIT(0))
+
+static void free_op_ACT(struct net *net, struct p4tc_cmd_operate *ope,
+			bool dec_act_refs, struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	struct tc_action *p = NULL;
+
+	A = GET_OPA(&ope->operands_list);
+	if (A)
+		p = A->action;
+
+	if (p) {
+		if (dec_act_refs) {
+			struct tcf_idrinfo *idrinfo = p->idrinfo;
+
+			atomic_dec(&p->tcfa_bindcnt);
+
+			if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt,
+							&idrinfo->lock)) {
+				idr_remove(&idrinfo->action_idr, p->tcfa_index);
+				mutex_unlock(&idrinfo->lock);
+
+				if (p->ops->cleanup)
+					p->ops->cleanup(p);
+
+				gen_kill_estimator(&p->tcfa_rate_est);
+				_free_tcf(p);
+			}
+		}
+	}
+
+	return _free_operation(net, ope, dec_act_refs, extack);
+}
+
+static inline int opnd_is_assignable(struct p4tc_cmd_operand *kopnd)
+{
+	return !(kopnd->oper_flags & DATA_IS_READ_ONLY);
+}
+
+static int validate_multiple_rvals(struct net *net, struct p4tc_act *act,
+				   struct p4tc_cmd_operate *ope,
+				   const size_t max_operands,
+				   const size_t max_size,
+				   struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *cursor;
+	int rvalue_tot_sz = 0;
+	int i = 0;
+	int err;
+
+	cursor = GET_OPA(&ope->operands_list);
+	list_for_each_entry_continue(cursor, &ope->operands_list, oper_list_node) {
+		struct p4tc_type *cursor_type;
+
+		if (i == max_operands - 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Operands list exceeds maximum allowed value");
+			return -EINVAL;
+		}
+
+		switch (cursor->oper_type) {
+		case P4TC_OPER_KEY:
+		case P4TC_OPER_META:
+		case P4TC_OPER_CONST:
+		case P4TC_OPER_HDRFIELD:
+		case P4TC_OPER_PARAM:
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Rvalue operand must be key, metadata, const, hdrfield or param");
+			return -EINVAL;
+		}
+
+		err = validate_operand(net, act, ope, cursor, extack);
+		if (err < 0)
+			return err;
+
+		cursor_type = cursor->oper_datatype;
+		if (!cursor_type->ops->host_read) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Rvalue operand's types must have host_read op");
+			return -EINVAL;
+		}
+
+		if (cursor_type->container_bitsz > max_size) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Rvalue operand's types must be <= 64 bits");
+			return -EINVAL;
+		}
+		if (cursor->oper_bitsize % 8 != 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "All Rvalues must have bitsize multiple of 8");
+			return -EINVAL;
+		}
+		rvalue_tot_sz += cursor->oper_bitsize;
+		i++;
+	}
+
+	if (i < 2) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Operation must have at least two operands");
+		return -EINVAL;
+	}
+
+	return rvalue_tot_sz;
+}
+
+static int __validate_CONCAT(struct net *net, struct p4tc_act *act,
+			     struct p4tc_cmd_operate *ope,
+			     const size_t max_operands,
+			     struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	A = GET_OPA(&ope->operands_list);
+	err = validate_operand(net, act, ope, A, extack);
+	if (err)		/*a better NL_SET_ERR_MSG_MOD done by validate_operand() */
+		return err;
+
+	if (!opnd_is_assignable(A)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unable to store op result in read-only operand");
+		return -EPERM;
+	}
+
+	return validate_multiple_rvals(net, act, ope, max_operands,
+				       P4T_MAX_BITSZ, extack);
+}
+
+static int __validate_BINARITH(struct net *net, struct p4tc_act *act,
+			       struct p4tc_cmd_operate *ope,
+			       const size_t max_operands,
+			       struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	struct p4tc_type *A_type;
+	int err;
+
+	A = GET_OPA(&ope->operands_list);
+	err = validate_operand(net, act, ope, A, extack);
+	if (err)		/*a better NL_SET_ERR_MSG_MOD done by validate_operand() */
+		return err > 0 ? -err : err;
+
+	if (!opnd_is_assignable(A)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unable to store op result in read-only operand");
+		return -EPERM;
+	}
+
+	switch (A->oper_type) {
+	case P4TC_OPER_META:
+	case P4TC_OPER_HDRFIELD:
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Operand A must be metadata or hdrfield");
+		return -EINVAL;
+	}
+
+	A_type = A->oper_datatype;
+	if (!A_type->ops->host_write) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Operand A's type must have host_write op");
+		return -EINVAL;
+	}
+
+	if (A_type->container_bitsz > 64) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Operand A's container type must be <= 64 bits");
+		return -EINVAL;
+	}
+
+	return validate_multiple_rvals(net, act, ope, max_operands, 64, extack);
+}
+
+static int validate_num_opnds(struct p4tc_cmd_operate *ope, u32 cmd_num_opnds)
+{
+	if (ope->num_opnds != cmd_num_opnds)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct p4tc_act_param *validate_act_param(struct p4tc_act *act,
+						 struct p4tc_cmd_operand *op,
+						 unsigned long *param_id,
+						 struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *nparam;
+	struct p4tc_act_param *param;
+
+	param = idr_get_next_ul(&act->params_idr, param_id);
+	if (!param) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Act has less runtime parameters than passed in call");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (op->oper_datatype->typeid != param->type) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand type differs from params");
+		return ERR_PTR(-EINVAL);
+	}
+	nparam = kzalloc(sizeof(*nparam), GFP_KERNEL);
+	if (!nparam)
+		return ERR_PTR(-ENOMEM);
+	strscpy(nparam->name, param->name, ACTPARAMNAMSIZ);
+	nparam->id = *param_id;
+	nparam->value = op;
+	nparam->type = param->type;
+	nparam->flags |= P4TC_ACT_PARAM_FLAGS_ISDYN;
+
+	return nparam;
+}
+
+static int validate_act_params(struct net *net, struct p4tc_act *act,
+			       struct p4tc_cmd_operate *ope,
+			       struct p4tc_cmd_operand *A,
+			       struct list_head *params_lst,
+			       struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *params[P4TC_MSGBATCH_SIZE] = { NULL };
+	unsigned long param_id = 0;
+	int i = 0;
+	struct p4tc_cmd_operand *kopnd;
+	int err;
+
+	kopnd = A;
+	list_for_each_entry_continue(kopnd, &ope->operands_list, oper_list_node) {
+		struct p4tc_act_param *nparam;
+
+		err = validate_operand(net, act, ope, kopnd, extack);
+		if (err)
+			goto free_params;
+
+		nparam = validate_act_param(act, kopnd, &param_id, extack);
+		if (IS_ERR(nparam)) {
+			err = PTR_ERR(nparam);
+			goto free_params;
+		}
+
+		params[i] = nparam;
+		list_add_tail(&nparam->head, params_lst);
+		i++;
+		param_id++;
+	}
+
+	if (idr_get_next_ul(&act->params_idr, &param_id)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Act has more runtime params than passed in call");
+		err = -EINVAL;
+		goto free_params;
+	}
+
+	return 0;
+
+free_params:
+	while (i--)
+		kfree(params[i]);
+
+	return err;
+}
+
+static void free_intermediate_params_list(struct list_head *params_list)
+{
+	struct p4tc_act_param *nparam, *p;
+
+	list_for_each_entry_safe(nparam, p, params_list, head)
+		kfree(nparam);
+}
+
+/* Actions with runtime parameters don't have instance ids (found in immedv2)
+ * because the action is not created apriori. Example:
+ * cmd act myprog.myact param1 param2 ... doesn't specify instance.
+ * As noted, it is equivalent to treating an action like a function call with
+ * action attributes derived at runtime.If these actions were already
+ * instantiated then immedv2 will have a non-zero value equal to the action index.
+ */
+static int check_runtime_params(struct p4tc_cmd_operate *ope,
+				struct p4tc_cmd_operand *A,
+				bool *is_runtime_act,
+				struct netlink_ext_ack *extack)
+{
+	if (A->immedv2 && ope->num_opnds > 1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't specify runtime params together with instance id");
+		return -EINVAL;
+	}
+
+	if (A->oper_flags & DATA_USES_ROOT_PIPE && !A->immedv2) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Must specify instance id for kernel act calls");
+		return -EINVAL;
+	}
+
+	*is_runtime_act = !A->immedv2;
+
+	return 0;
+}
+
+/* Syntax: act ACTION_ID ACTION_INDEX | act ACTION_ID/ACTION_NAME PARAMS
+ * Operation: The tc action instance of kind ID ACTION_ID and optional index ACTION_INDEX
+ * is executed.
+ */
+int validate_ACT(struct net *net, struct p4tc_act *act,
+		 struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		 struct netlink_ext_ack *extack)
+{
+	struct tc_action_ops *action_ops;
+	struct list_head params_list;
+	struct p4tc_cmd_operand *A, *B;
+	struct tc_action *action;
+	bool is_runtime_act;
+	int err;
+
+	INIT_LIST_HEAD(&params_list);
+
+	A = GET_OPA(&ope->operands_list);
+	err = validate_operand(net, act, ope, A, extack);
+	if (err < 0)
+		return err;
+
+	if (A->oper_type != P4TC_OPER_ACTID) {
+		NL_SET_ERR_MSG_MOD(extack, "ACT: Operand type MUST be P4TC_OPER_ACTID\n");
+		return -EINVAL;
+	}
+
+	err = check_runtime_params(ope, A, &is_runtime_act, extack);
+	if (err < 0)
+		return err;
+
+	B = GET_OPB(&ope->operands_list);
+	A->oper_datatype = p4type_find_byid(P4T_U32);
+
+	if (A->oper_flags & DATA_USES_ROOT_PIPE) {
+		action_ops = tc_lookup_action_byid(A->immedv);
+		if (!action_ops) {
+			NL_SET_ERR_MSG_MOD(extack, "ACT: unknown Action Kind");
+			return -EINVAL;
+		}
+		A->pipeid = 0;
+	} else {
+		struct p4tc_pipeline *pipeline = act->pipeline;
+		struct p4tc_act_dep_edge_node *edge_node;
+		struct p4tc_act *callee_act;
+		bool has_back_edge;
+
+		/* lets check if we have cycles where we are calling an
+		 * action that might end calling us
+		 */
+		callee_act = tcf_action_get(pipeline,
+					    (const char *)A->path_or_value,
+					    A->immedv, extack);
+		if (IS_ERR(callee_act))
+			return PTR_ERR(callee_act);
+
+		A->pipeid = act->pipeline->common.p_id;
+		A->immedv = callee_act->a_id;
+
+		edge_node = kzalloc(sizeof(*edge_node), GFP_KERNEL);
+		if (!edge_node) {
+			err = -ENOMEM;
+			goto free_params_list;
+		}
+		edge_node->act_id = act->a_id;
+
+		has_back_edge = tcf_pipeline_check_act_backedge(pipeline,
+								edge_node,
+								callee_act->a_id);
+		if (has_back_edge) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Call creates a back edge: %s -> %s",
+					       act->common.name,
+					       callee_act->common.name);
+			err = -EINVAL;
+			kfree(edge_node);
+			goto free_params_list;
+		}
+
+		A->priv = edge_node;
+		if (is_runtime_act) {
+			u32 flags = TCA_ACT_FLAGS_BIND;
+			struct tc_act_dyna parm = { 0 };
+
+			err = validate_act_params(net, callee_act, ope, A,
+						  &params_list, extack);
+			if (err < 0)
+				return err;
+
+			parm.action = TC_ACT_PIPE;
+			err = tcf_p4_dyna_template_init(net, &action,
+							callee_act,
+							&params_list, &parm,
+							flags, extack);
+			if (err < 0)
+				goto free_params_list;
+
+			ope->op_flags |= P4TC_CMD_OPER_ACT_RUNTIME;
+		}
+
+		action_ops = &callee_act->ops;
+	}
+
+	if (!is_runtime_act) {
+		if (__tcf_idr_search(net, action_ops, &action, A->immedv2) == false) {
+			NL_SET_ERR_MSG_MOD(extack, "ACT: unknown Action index\n");
+			module_put(action_ops->owner);
+			err = -EINVAL;
+			goto free_params_list;
+		}
+
+		atomic_inc(&action->tcfa_bindcnt);
+	}
+
+	A->immedv2 = action->tcfa_index;
+	A->action = action;
+
+	return 0;
+
+free_params_list:
+	free_intermediate_params_list(&params_list);
+	return err;
+}
+
+/* Syntax: set A B
+ * Operation: B is written to A.
+ * A could header, or metadata or key
+ * B could be a constant, header, or metadata
+ * Restriction: A and B dont have to be of the same size and type
+ * as long as B's value could be less bits than A
+ * (example a U16 setting into a U32, etc)
+ */
+int validate_SET(struct net *net, struct p4tc_act *act,
+		 struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		 struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A, *B;
+	struct p4tc_type *A_type;
+	struct p4tc_type *B_type;
+	int err = 0;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "SET must have only 2 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+	err = validate_operand(net, act, ope, A, extack);
+	if (err) /*a better NL_SET_ERR_MSG_MOD done by validate_operand() */
+		return err;
+
+	if (!opnd_is_assignable(A)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set read-only operand");
+		return -EPERM;
+	}
+
+	B = GET_OPB(&ope->operands_list);
+	if (B->oper_type == P4TC_OPER_KEY) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand B cannot be key\n");
+		return -EINVAL;
+	}
+
+	err = validate_operand(net, act, ope, B, extack);
+	if (err)
+		return err;
+
+	A_type = A->oper_datatype;
+	B_type = B->oper_datatype;
+	if (A->oper_type == P4TC_OPER_KEY)
+		A->oper_datatype = B_type;
+
+	if ((A_type->typeid == P4T_DEV && B_type->typeid != P4T_DEV) ||
+	    (A_type->typeid != P4T_DEV && B_type->typeid == P4T_DEV)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can only set dev to other dev");
+		return -EINVAL;
+	}
+
+	if (!A_type->ops->host_read || !B_type->ops->host_read) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Types of A and B must have host_read op");
+		return -EINVAL;
+	}
+
+	if (!A_type->ops->host_write || !B_type->ops->host_write) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Types of A and B must have host_write op");
+		return -EINVAL;
+	}
+
+	if (A->oper_bitsize < B->oper_bitsize) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "set: B.bitsize has to be <= A.bitsize\n");
+		return -EINVAL;
+	}
+
+	if (A->oper_bitsize != B->oper_bitsize) {
+		/* We allow them as long as the value of B can fit in A
+		 * which has already been verified at this point
+		 */
+		u64 Amaxval;
+		u64 Bmaxval;
+
+		/* Anything can be assigned to P4T_U128 */
+		if (A->oper_datatype->typeid == P4T_U128)
+			return 0;
+
+		Amaxval = GENMASK_ULL(A->oper_bitend, A->oper_bitstart);
+
+		if (B->oper_type == P4TC_OPER_CONST)
+			Bmaxval = B->immedv;
+		else
+			Bmaxval = GENMASK_ULL(B->oper_bitend, B->oper_bitstart);
+
+		if (Bmaxval > Amaxval) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "set: B bits has to fit in A\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int validate_PRINT(struct net *net, struct p4tc_act *act,
+		   struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		   struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "print must have only 1 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+
+	if (A->oper_type == P4TC_OPER_CONST) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand A cannot be constant\n");
+		return -EINVAL;
+	}
+
+	return validate_operand(net, act, ope, A, extack);
+}
+
+int validate_TBLAPP(struct net *net, struct p4tc_act *act,
+		    struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		    struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "tableapply must have only 1 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+	if (A->oper_type != P4TC_OPER_TBL) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand A must be a table\n");
+		return -EINVAL;
+	}
+
+	err = validate_operand(net, act, ope, A, extack);
+	if (err) /*a better NL_SET_ERR_MSG_MOD done by validate_operand() */
+		return err;
+
+	return 0;
+}
+
+int validate_SNDPORTEGR(struct net *net, struct p4tc_act *act,
+			struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+			struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "send_port_egress must have only 1 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+
+	err = validate_operand(net, act, ope, A, extack);
+	if (err) /*a better NL_SET_ERR_MSG_MOD done by validate_operand() */
+		return err;
+
+	return 0;
+}
+
+int validate_BINARITH(struct net *net, struct p4tc_act *act,
+		      struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		      struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A, *B, *C;
+	struct p4tc_type *A_type;
+	struct p4tc_type *B_type;
+	struct p4tc_type *C_type;
+	int err;
+
+	err = __validate_BINARITH(net, act, ope, cmd_num_opnds, extack);
+	if (err < 0)
+		return err;
+
+	A = GET_OPA(&ope->operands_list);
+	B = GET_OPB(&ope->operands_list);
+	C = GET_OPC(&ope->operands_list);
+
+	A_type = A->oper_datatype;
+	B_type = B->oper_datatype;
+	C_type = C->oper_datatype;
+
+	/* For now, they must be the same.
+	 * Will change that very soon.
+	 */
+	if (A_type != B_type || A_type != C_type) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Type of A, B and C must be the same");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int validate_CONCAT(struct net *net, struct p4tc_act *act,
+		    struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		    struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int rvalue_tot_sz;
+
+	A = GET_OPA(&ope->operands_list);
+
+	rvalue_tot_sz = __validate_CONCAT(net, act, ope, cmd_num_opnds, extack);
+	if (rvalue_tot_sz < 0)
+		return rvalue_tot_sz;
+
+	if (A->oper_bitsize < rvalue_tot_sz) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Rvalue operands concatenated must fit inside operand A");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* We'll validate jump to labels later once we have all labels processed */
+int validate_JUMP(struct net *net, struct p4tc_act *act,
+		  struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		  struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "jump must have only 1 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+	if (A->oper_type != P4TC_OPER_LABEL) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand A must be a label\n");
+		return -EINVAL;
+	}
+
+	if (A->immedv) {
+		int jmp_num;
+
+		jmp_num = A->immedv & TC_ACT_EXT_VAL_MASK;
+
+		if (jmp_num <= 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Backward jumps are not allowed");
+			return -EINVAL;
+		}
+	}
+
+	A->oper_datatype = p4type_find_byid(P4T_U32);
+
+	return 0;
+}
+
+int validate_LABEL(struct net *net, struct p4tc_act *act,
+		   struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		   struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A;
+	int err;
+
+	err = validate_num_opnds(ope, cmd_num_opnds);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "label must have only 1 operands");
+		return err;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+	if (A->oper_type != P4TC_OPER_LABEL) {
+		NL_SET_ERR_MSG_MOD(extack, "Operand A must be a label\n");
+		return -EINVAL;
+	}
+
+	err = validate_operand(net, act, ope, A, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void p4tc_reg_lock(struct p4tc_cmd_operand *A,
+			  struct p4tc_cmd_operand *B,
+			  struct p4tc_cmd_operand *C)
+{
+	struct p4tc_register *reg_A, *reg_B, *reg_C;
+
+	if (A->oper_type == P4TC_OPER_REG) {
+		reg_A = A->priv;
+		spin_lock_bh(&reg_A->reg_value_lock);
+	}
+
+	if (B && B->oper_type == P4TC_OPER_REG) {
+		reg_B = B->priv;
+		spin_lock_bh(&reg_B->reg_value_lock);
+	}
+
+	if (C && C->oper_type == P4TC_OPER_REG) {
+		reg_C = C->priv;
+		spin_lock_bh(&reg_C->reg_value_lock);
+	}
+}
+
+static void p4tc_reg_unlock(struct p4tc_cmd_operand *A,
+			    struct p4tc_cmd_operand *B,
+			    struct p4tc_cmd_operand *C)
+{
+	struct p4tc_register *reg_A, *reg_B, *reg_C;
+
+	if (C && C->oper_type == P4TC_OPER_REG) {
+		reg_C = C->priv;
+		spin_unlock_bh(&reg_C->reg_value_lock);
+	}
+
+	if (B && B->oper_type == P4TC_OPER_REG) {
+		reg_B = B->priv;
+		spin_unlock_bh(&reg_B->reg_value_lock);
+	}
+
+	if (A->oper_type == P4TC_OPER_REG) {
+		reg_A = A->priv;
+		spin_unlock_bh(&reg_A->reg_value_lock);
+	}
+}
+
+static int p4tc_cmp_op(struct p4tc_cmd_operand *A, struct p4tc_cmd_operand *B,
+		       void *A_val, void *B_val)
+{
+	int res;
+
+	p4tc_reg_lock(A, B, NULL);
+
+	res = p4t_cmp(A->oper_mask_shift, A->oper_datatype, A_val,
+		      B->oper_mask_shift, B->oper_datatype, B_val);
+
+	p4tc_reg_unlock(A, B, NULL);
+
+	return res;
+}
+
+static int p4tc_copy_op(struct p4tc_cmd_operand *A, struct p4tc_cmd_operand *B,
+			void *A_val, void *B_val)
+{
+	int res;
+
+	p4tc_reg_lock(A, B, NULL);
+
+	res = p4t_copy(A->oper_mask_shift, A->oper_datatype, A_val,
+		       B->oper_mask_shift, B->oper_datatype, B_val);
+
+	p4tc_reg_unlock(A, B, NULL);
+
+	return res;
+}
+
+/* Syntax: BRANCHOP A B
+ * BRANCHOP := BEQ, BNEQ, etc
+ * Operation: B's value is compared to A's value.
+ * XXX: In the future we will take expressions instead of values
+ * A could a constant, header, or metadata or key
+ * B could be a constant, header, metadata, or key
+ * Restriction: A and B cannot both be constants
+ */
+
+/* if A == B <ctl1> else <ctl2> */
+static int p4tc_cmd_BEQ(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (!res_cmp)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+/* if A != B <ctl1> else <ctl2> */
+static int p4tc_cmd_BNE(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (res_cmp)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+/* if A < B <ctl1> else <ctl2> */
+static int p4tc_cmd_BLT(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (res_cmp < 0)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+/* if A <= B <ctl1> else <ctl2> */
+static int p4tc_cmd_BLE(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (!res_cmp || res_cmp < 0)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+/* if A > B <ctl1> else <ctl2> */
+static int p4tc_cmd_BGT(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (res_cmp > 0)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+/* if A >= B <ctl1> else <ctl2> */
+static int p4tc_cmd_BGE(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int res_cmp;
+	void *B_val;
+	void *A_val;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	A_val = A->fetch(skb, A, cmd, res);
+	B_val = B->fetch(skb, B, cmd, res);
+
+	if (!A_val || !B_val)
+		return TC_ACT_OK;
+
+	res_cmp = p4tc_cmp_op(A, B, A_val, B_val);
+	if (!res_cmp || res_cmp > 0)
+		return op->ctl1;
+
+	return op->ctl2;
+}
+
+int validate_BRN(struct net *net, struct p4tc_act *act,
+		 struct p4tc_cmd_operate *ope, u32 cmd_num_opnds,
+		 struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operand *A, *B;
+	int err = 0;
+
+	if (validate_num_opnds(ope, cmd_num_opnds) < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Branch: branch must have only 2 operands");
+		return -EINVAL;
+	}
+
+	A = GET_OPA(&ope->operands_list);
+	B = GET_OPB(&ope->operands_list);
+
+	err = validate_operand(net, act, ope, A, extack);
+	if (err)
+		return err;
+
+	err = validate_operand(net, act, ope, B, extack);
+	if (err)
+		return err;
+
+	if (A->oper_type == P4TC_OPER_CONST &&
+	    B->oper_type == P4TC_OPER_CONST) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Branch: A and B can't both be constant\n");
+		return -EINVAL;
+	}
+
+	if (!p4tc_type_unsigned(A->oper_datatype->typeid) ||
+	    !p4tc_type_unsigned(B->oper_datatype->typeid)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Operands A and B must be unsigned\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void generic_free_op(struct net *net, struct p4tc_cmd_operate *ope,
+			    bool called_from_template,
+			    struct netlink_ext_ack *extack)
+{
+	return _free_operation(net, ope, called_from_template, extack);
+}
+
+static struct p4tc_cmd_s cmds[] = {
+	{ P4TC_CMD_OP_SET, 2, validate_SET, generic_free_op, p4tc_cmd_SET },
+	{ P4TC_CMD_OP_ACT, 1, validate_ACT, free_op_ACT, p4tc_cmd_ACT },
+	{ P4TC_CMD_OP_BEQ, 2, validate_BRN, generic_free_op, p4tc_cmd_BEQ },
+	{ P4TC_CMD_OP_BNE, 2, validate_BRN, generic_free_op, p4tc_cmd_BNE },
+	{ P4TC_CMD_OP_BGT, 2, validate_BRN, generic_free_op, p4tc_cmd_BGT },
+	{ P4TC_CMD_OP_BLT, 2, validate_BRN, generic_free_op, p4tc_cmd_BLT },
+	{ P4TC_CMD_OP_BGE, 2, validate_BRN, generic_free_op, p4tc_cmd_BGE },
+	{ P4TC_CMD_OP_BLE, 2, validate_BRN, generic_free_op, p4tc_cmd_BLE },
+	{ P4TC_CMD_OP_PRINT, 1, validate_PRINT, generic_free_op,
+	  p4tc_cmd_PRINT },
+	{ P4TC_CMD_OP_TBLAPP, 1, validate_TBLAPP, generic_free_op,
+	  p4tc_cmd_TBLAPP },
+	{ P4TC_CMD_OP_SNDPORTEGR, 1, validate_SNDPORTEGR, generic_free_op,
+	  p4tc_cmd_SNDPORTEGR },
+	{ P4TC_CMD_OP_MIRPORTEGR, 1, validate_SNDPORTEGR, generic_free_op,
+	  p4tc_cmd_MIRPORTEGR },
+	{ P4TC_CMD_OP_PLUS, 3, validate_BINARITH, generic_free_op,
+	  p4tc_cmd_PLUS },
+	{ P4TC_CMD_OP_SUB, 3, validate_BINARITH, generic_free_op,
+	  p4tc_cmd_SUB },
+	{ P4TC_CMD_OP_CONCAT, P4TC_CMD_OPERS_MAX, validate_CONCAT,
+	  generic_free_op, p4tc_cmd_CONCAT },
+	{ P4TC_CMD_OP_BAND, 3, validate_BINARITH, generic_free_op,
+	  p4tc_cmd_BAND },
+	{ P4TC_CMD_OP_BOR, 3, validate_BINARITH, generic_free_op,
+	  p4tc_cmd_BOR },
+	{ P4TC_CMD_OP_BXOR, 3, validate_BINARITH, generic_free_op,
+	  p4tc_cmd_BXOR },
+	{ P4TC_CMD_OP_JUMP, 1, validate_JUMP, generic_free_op, p4tc_cmd_JUMP },
+	{ P4TC_CMD_OP_LABEL, 1, validate_LABEL, generic_free_op, NULL },
+};
+
+static struct p4tc_cmd_s *p4tc_get_cmd_byid(u16 cmdid)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cmds); i++) {
+		if (cmdid == cmds[i].cmdid)
+			return &cmds[i];
+	}
+
+	return NULL;
+}
+
+/* Operands */
+static const struct nla_policy p4tc_cmd_policy_oper[P4TC_CMD_OPND_MAX + 1] = {
+	[P4TC_CMD_OPND_INFO] = { .type = NLA_BINARY,
+				    .len = sizeof(struct p4tc_u_operand) },
+	[P4TC_CMD_OPND_PATH] = { .type = NLA_STRING, .len = TEMPLATENAMSZ },
+	[P4TC_CMD_OPND_PATH_EXTRA] = { .type = NLA_STRING, .len = TEMPLATENAMSZ },
+	[P4TC_CMD_OPND_LARGE_CONSTANT] = {
+		.type = NLA_BINARY,
+		.len = BITS_TO_BYTES(P4T_MAX_BITSZ),
+	},
+	[P4TC_CMD_OPND_PREFIX] = { .type = NLA_STRING, .len = TEMPLATENAMSZ },
+};
+
+/* XXX: P4TC_CMD_POLICY is used to disable overwriting extacks downstream
+ * Could we use error pointers instead of this P4TC_CMD_POLICY trickery?
+ */
+#define P4TC_CMD_POLICY 12345
+static int p4tc_cmds_process_opnd(struct nlattr *nla,
+				  struct p4tc_cmd_operand *kopnd,
+				  struct netlink_ext_ack *extack)
+{
+	int oper_extra_sz = 0;
+	int oper_prefix_sz = 0;
+	u32 wantbits = 0;
+	int oper_sz = 0;
+	int err = 0;
+	struct nlattr *tb[P4TC_CMD_OPND_MAX + 1];
+	struct p4tc_u_operand *uopnd;
+
+	err = nla_parse_nested(tb, P4TC_CMD_OPND_MAX, nla, p4tc_cmd_policy_oper,
+			       extack);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "parse error: P4TC_CMD_OPND_\n");
+		return -EINVAL;
+	}
+
+	if (!tb[P4TC_CMD_OPND_INFO]) {
+		NL_SET_ERR_MSG_MOD(extack, "operand information is mandatory");
+		return -EINVAL;
+	}
+
+	uopnd = nla_data(tb[P4TC_CMD_OPND_INFO]);
+
+	if (uopnd->oper_type == P4TC_OPER_META) {
+		kopnd->fetch = p4tc_fetch_metadata;
+	} else if (uopnd->oper_type == P4TC_OPER_CONST) {
+		kopnd->fetch = p4tc_fetch_constant;
+	} else if (uopnd->oper_type == P4TC_OPER_ACTID) {
+		kopnd->fetch = NULL;
+	} else if (uopnd->oper_type == P4TC_OPER_TBL) {
+		kopnd->fetch = p4tc_fetch_table;
+	} else if (uopnd->oper_type == P4TC_OPER_KEY) {
+		kopnd->fetch = p4tc_fetch_key;
+	} else if (uopnd->oper_type == P4TC_OPER_RES) {
+		kopnd->fetch = p4tc_fetch_result;
+	} else if (uopnd->oper_type == P4TC_OPER_HDRFIELD) {
+		kopnd->fetch = p4tc_fetch_hdrfield;
+	} else if (uopnd->oper_type == P4TC_OPER_PARAM) {
+		kopnd->fetch = p4tc_fetch_param;
+	} else if (uopnd->oper_type == P4TC_OPER_DEV) {
+		kopnd->fetch = p4tc_fetch_dev;
+	} else if (uopnd->oper_type == P4TC_OPER_REG) {
+		kopnd->fetch = p4tc_fetch_reg;
+	} else if (uopnd->oper_type == P4TC_OPER_LABEL) {
+		kopnd->fetch = NULL;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown operand type");
+		return -EINVAL;
+	}
+
+	wantbits = 1 + uopnd->oper_endbit - uopnd->oper_startbit;
+	if (uopnd->oper_flags & DATA_HAS_TYPE_INFO &&
+	    uopnd->oper_type != P4TC_OPER_ACTID &&
+	    uopnd->oper_type != P4TC_OPER_TBL &&
+	    uopnd->oper_type != P4TC_OPER_REG &&
+	    uopnd->oper_cbitsize < wantbits) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Start and end bit dont fit in space");
+		return -EINVAL;
+	}
+
+	err = copy_u2k_operand(uopnd, kopnd, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[P4TC_CMD_OPND_LARGE_CONSTANT]) {
+		int const_sz;
+
+		const_sz = nla_len(tb[P4TC_CMD_OPND_LARGE_CONSTANT]);
+		if (const_sz)
+			memcpy(kopnd->immedv_large,
+			       nla_data(tb[P4TC_CMD_OPND_LARGE_CONSTANT]),
+			       const_sz);
+		else
+			kopnd->oper_flags |= DATA_IS_IMMEDIATE;
+
+		kopnd->immedv_large_sz = const_sz;
+	}
+
+	if (tb[P4TC_CMD_OPND_PATH])
+		oper_sz = nla_len(tb[P4TC_CMD_OPND_PATH]);
+
+	kopnd->path_or_value_sz = oper_sz;
+
+	if (oper_sz) {
+		kopnd->path_or_value = kzalloc(oper_sz, GFP_KERNEL);
+		if (!kopnd->path_or_value) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to alloc operand path data");
+			return -ENOMEM;
+		}
+
+		nla_memcpy(kopnd->path_or_value, tb[P4TC_CMD_OPND_PATH],
+			   oper_sz);
+	}
+
+	if (tb[P4TC_CMD_OPND_PATH_EXTRA])
+		oper_extra_sz = nla_len(tb[P4TC_CMD_OPND_PATH_EXTRA]);
+
+	kopnd->path_or_value_extra_sz = oper_extra_sz;
+
+	if (oper_extra_sz) {
+		kopnd->path_or_value_extra = kzalloc(oper_extra_sz, GFP_KERNEL);
+		if (!kopnd->path_or_value_extra) {
+			kfree(kopnd->path_or_value);
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to alloc extra operand path data");
+			return -ENOMEM;
+		}
+
+		nla_memcpy(kopnd->path_or_value_extra,
+			   tb[P4TC_CMD_OPND_PATH_EXTRA], oper_extra_sz);
+	}
+
+	if (tb[P4TC_CMD_OPND_PREFIX])
+		oper_prefix_sz = nla_len(tb[P4TC_CMD_OPND_PREFIX]);
+
+	if (!oper_prefix_sz)
+		return 0;
+
+	kopnd->print_prefix_sz = oper_prefix_sz;
+
+	kopnd->print_prefix = kzalloc(oper_prefix_sz, GFP_KERNEL);
+	if (!kopnd->print_prefix) {
+		kfree(kopnd->path_or_value);
+		kfree(kopnd->path_or_value_extra);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to alloc operand print prefix");
+		return -ENOMEM;
+	}
+
+	nla_memcpy(kopnd->print_prefix, tb[P4TC_CMD_OPND_PREFIX],
+		   oper_prefix_sz);
+	return 0;
+}
+
+/* Operation */
+static const struct nla_policy cmd_ops_policy[P4TC_CMD_OPER_MAX + 1] = {
+	[P4TC_CMD_OPERATION] = { .type = NLA_BINARY,
+				 .len = sizeof(struct p4tc_u_operate) },
+	[P4TC_CMD_OPER_LIST] = { .type = NLA_NESTED },
+	[P4TC_CMD_OPER_LABEL1] = { .type = NLA_STRING, .len = LABELNAMSIZ },
+	[P4TC_CMD_OPER_LABEL2] = { .type = NLA_STRING, .len = LABELNAMSIZ },
+};
+
+static struct p4tc_cmd_operate *uope_to_kope(struct p4tc_u_operate *uope)
+{
+	struct p4tc_cmd_operate *ope;
+
+	if (!uope)
+		return NULL;
+
+	ope = kzalloc(sizeof(*ope), GFP_KERNEL);
+	if (!ope)
+		return NULL;
+
+	ope->op_id = uope->op_type;
+	ope->op_flags = uope->op_flags;
+	ope->op_cnt = 0;
+
+	ope->ctl1 = uope->op_ctl1;
+	ope->ctl2 = uope->op_ctl2;
+
+	INIT_LIST_HEAD(&ope->operands_list);
+
+	return ope;
+}
+
+static int p4tc_cmd_process_operands_list(struct nlattr *nla,
+					  struct p4tc_cmd_operate *ope,
+					  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_CMD_OPERS_MAX + 1];
+	struct p4tc_cmd_operand *opnd;
+	int err;
+	int i;
+
+	err = nla_parse_nested(tb, P4TC_CMD_OPERS_MAX, nla, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	for (i = 1; i < P4TC_CMD_OPERS_MAX + 1 && tb[i]; i++) {
+		opnd = kzalloc(sizeof(*opnd), GFP_KERNEL);
+		if (!opnd)
+			return -ENOMEM;
+		err = p4tc_cmds_process_opnd(tb[i], opnd, extack);
+		/* Will add to list because p4tc_cmd_process_opnd may have
+		 * allocated memory inside opnd even in case of failure,
+		 * and this memory must be freed
+		 */
+		list_add_tail(&opnd->oper_list_node, &ope->operands_list);
+		if (err < 0)
+			return P4TC_CMD_POLICY;
+		ope->num_opnds++;
+	}
+
+	return 0;
+}
+
+static int p4tc_cmd_process_ops(struct net *net, struct p4tc_act *act,
+				struct nlattr *nla,
+				struct p4tc_cmd_operate **op_entry,
+				int cmd_offset, struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operate *ope = NULL;
+	int err = 0;
+	struct nlattr *tb[P4TC_CMD_OPER_MAX + 1];
+	struct p4tc_cmd_s *cmd_t;
+
+	err = nla_parse_nested(tb, P4TC_CMD_OPER_MAX, nla, cmd_ops_policy,
+			       extack);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "parse error: P4TC_CMD_OPER_\n");
+		return P4TC_CMD_POLICY;
+	}
+
+	ope = uope_to_kope(nla_data(tb[P4TC_CMD_OPERATION]));
+	if (!ope)
+		return -ENOMEM;
+
+	ope->cmd_offset = cmd_offset;
+
+	cmd_t = p4tc_get_cmd_byid(ope->op_id);
+	if (!cmd_t) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown operation ID\n");
+		kfree(ope);
+		return -EINVAL;
+	}
+
+	if (tb[P4TC_CMD_OPER_LABEL1]) {
+		const char *label1 = nla_data(tb[P4TC_CMD_OPER_LABEL1]);
+		const u32 label1_sz = nla_len(tb[P4TC_CMD_OPER_LABEL1]);
+
+		ope->label1 = kzalloc(label1_sz, GFP_KERNEL);
+		if (!ope->label1)
+			return P4TC_CMD_POLICY;
+
+		strscpy(ope->label1, label1, label1_sz);
+	}
+
+	if (tb[P4TC_CMD_OPER_LABEL2]) {
+		const char *label2 = nla_data(tb[P4TC_CMD_OPER_LABEL2]);
+		const u32 label2_sz = nla_len(tb[P4TC_CMD_OPER_LABEL2]);
+
+		ope->label2 = kzalloc(label2_sz, GFP_KERNEL);
+		if (!ope->label2)
+			return P4TC_CMD_POLICY;
+
+		strscpy(ope->label2, label2, label2_sz);
+	}
+
+	if (tb[P4TC_CMD_OPER_LIST]) {
+		err = p4tc_cmd_process_operands_list(tb[P4TC_CMD_OPER_LIST],
+						     ope, extack);
+		if (err) {
+			err = P4TC_CMD_POLICY;
+			goto set_results;
+		}
+	}
+
+	err = cmd_t->validate_operands(net, act, ope, cmd_t->num_opnds, extack);
+	if (err) {
+		//XXX: think about getting rid of this P4TC_CMD_POLICY
+		err = P4TC_CMD_POLICY;
+		goto set_results;
+	}
+
+set_results:
+	ope->cmd = cmd_t;
+	*op_entry = ope;
+
+	return err;
+}
+
+static inline int cmd_is_branch(u32 cmdid)
+{
+	if (cmdid == P4TC_CMD_OP_BEQ || cmdid == P4TC_CMD_OP_BNE ||
+	    cmdid == P4TC_CMD_OP_BLT || cmdid == P4TC_CMD_OP_BLE ||
+	    cmdid == P4TC_CMD_OP_BGT || cmdid == P4TC_CMD_OP_BGE)
+		return 1;
+
+	return 0;
+}
+
+static int cmd_jump_operand_validate(struct p4tc_act *act,
+				     struct p4tc_cmd_operate *ope,
+				     struct p4tc_cmd_operand *kopnd, int cmdcnt,
+				     struct netlink_ext_ack *extack)
+{
+	int jmp_cnt, cmd_offset;
+
+	cmd_offset = cmd_find_label_offset(act,
+					   (const char *)kopnd->path_or_value,
+					   extack);
+	if (cmd_offset < 0)
+		return cmd_offset;
+
+	if (cmd_offset >= cmdcnt) {
+		NL_SET_ERR_MSG(extack, "Jump excessive branch");
+		return -EINVAL;
+	}
+
+	jmp_cnt = cmd_offset - ope->cmd_offset - 1;
+	if (jmp_cnt <= 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Backward jumps are not allowed");
+		return -EINVAL;
+	}
+
+	kopnd->immedv = TC_ACT_JUMP | jmp_cnt;
+
+	return 0;
+}
+
+static int cmd_brn_validate(struct p4tc_act *act,
+			    struct p4tc_cmd_operate *oplist[], int cnt,
+			    struct netlink_ext_ack *extack)
+{
+	int cmdcnt = cnt - 1;
+	int i;
+
+	for (i = 1; i < cmdcnt; i++) {
+		struct p4tc_cmd_operate *ope = oplist[i - 1];
+		int jmp_cnt = 0;
+		struct p4tc_cmd_operand *kopnd;
+
+		if (ope->op_id == P4TC_CMD_OP_JUMP) {
+			list_for_each_entry(kopnd, &ope->operands_list, oper_list_node) {
+				int ret;
+
+				if (kopnd->immedv) {
+					jmp_cnt = kopnd->immedv & TC_ACT_EXT_VAL_MASK;
+					if (jmp_cnt + i >= cmdcnt) {
+						NL_SET_ERR_MSG(extack,
+							       "jump excessive branch");
+						return -EINVAL;
+					}
+				} else {
+					ret = cmd_jump_operand_validate(act, ope,
+									kopnd,
+									cmdcnt, extack);
+					if (ret < 0)
+						return ret;
+				}
+			}
+		}
+
+		if (!cmd_is_branch(ope->op_id))
+			continue;
+
+		if (TC_ACT_EXT_CMP(ope->ctl1, TC_ACT_JUMP)) {
+			if (ope->label1) {
+				int cmd_offset;
+
+				cmd_offset = cmd_find_label_offset(act,
+								   ope->label1,
+								   extack);
+				if (cmd_offset < 0)
+					return -EINVAL;
+				jmp_cnt = cmd_offset - ope->cmd_offset;
+
+				if (jmp_cnt <= 0) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "Backward jumps are not allowed");
+					return -EINVAL;
+				}
+				ope->ctl1 |= jmp_cnt;
+			} else {
+				jmp_cnt = ope->ctl1 & TC_ACT_EXT_VAL_MASK;
+				if (jmp_cnt + i >= cmdcnt) {
+					NL_SET_ERR_MSG(extack,
+						       "ctl1 excessive branch");
+					return -EINVAL;
+				}
+			}
+		}
+
+		if (TC_ACT_EXT_CMP(ope->ctl2, TC_ACT_JUMP)) {
+			if (ope->label2) {
+				int cmd_offset;
+
+				cmd_offset = cmd_find_label_offset(act,
+								   ope->label2,
+								   extack);
+				if (cmd_offset < 0)
+					return -EINVAL;
+				jmp_cnt = cmd_offset - ope->cmd_offset;
+
+				if (jmp_cnt <= 0) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "Backward jumps are not allowed");
+					return -EINVAL;
+				}
+				ope->ctl2 |= jmp_cnt;
+			} else {
+				jmp_cnt = ope->ctl2 & TC_ACT_EXT_VAL_MASK;
+				if (jmp_cnt + i >= cmdcnt) {
+					NL_SET_ERR_MSG(extack,
+						       "ctl2 excessive branch");
+					return -EINVAL;
+				}
+			}
+		}
+	}
+
+	return 0;
+}
+
+static void p4tc_cmds_insert_acts(struct p4tc_act *act,
+				  struct p4tc_cmd_operate *ope)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = { NULL };
+	int i = 0;
+	struct p4tc_cmd_operand *kopnd;
+
+	list_for_each_entry(kopnd, &ope->operands_list, oper_list_node) {
+		if (kopnd->oper_type == P4TC_OPER_ACTID &&
+		    !(kopnd->oper_flags & DATA_USES_ROOT_PIPE)) {
+			struct p4tc_act_dep_edge_node *edge_node = kopnd->priv;
+			struct tcf_p4act *p = to_p4act(kopnd->action);
+
+			/* Add to the dependency graph so we can detect
+			 * circular references
+			 */
+			tcf_pipeline_add_dep_edge(act->pipeline, edge_node,
+						  p->act_id);
+			kopnd->priv = NULL;
+
+			actions[i] = kopnd->action;
+			i++;
+		}
+	}
+
+	tcf_idr_insert_many(actions);
+}
+
+static void p4tc_cmds_ops_pass_to_list(struct p4tc_act *act,
+				       struct p4tc_cmd_operate **oplist,
+				       struct list_head *cmd_operations,
+				       bool called_from_instance)
+{
+	int i;
+
+	for (i = 0; i < P4TC_CMDS_LIST_MAX && oplist[i]; i++) {
+		struct p4tc_cmd_operate *ope = oplist[i];
+
+		if (!called_from_instance)
+			p4tc_cmds_insert_acts(act, ope);
+
+		list_add_tail(&ope->cmd_operations, cmd_operations);
+	}
+}
+
+static void p4tc_cmd_ops_del_list(struct net *net,
+				  struct list_head *cmd_operations)
+{
+	struct p4tc_cmd_operate *ope, *tmp;
+
+	list_for_each_entry_safe(ope, tmp, cmd_operations, cmd_operations) {
+		list_del(&ope->cmd_operations);
+		kfree_opentry(net, ope, false);
+	}
+}
+
+static int p4tc_cmds_copy_opnd(struct p4tc_act *act,
+			       struct p4tc_cmd_operand **new_kopnd,
+			       struct p4tc_cmd_operand *kopnd,
+			       struct netlink_ext_ack *extack)
+{
+	struct p4tc_type_mask_shift *mask_shift = NULL;
+	struct p4tc_cmd_operand *_new_kopnd;
+	int err = 0;
+
+	_new_kopnd = kzalloc(sizeof(*_new_kopnd), GFP_KERNEL);
+	if (!_new_kopnd)
+		return -ENOMEM;
+
+	memcpy(_new_kopnd, kopnd, sizeof(*_new_kopnd));
+	memset(&_new_kopnd->oper_list_node, 0, sizeof(struct list_head));
+
+	if (kopnd->oper_type == P4TC_OPER_CONST &&
+	    kopnd->oper_datatype->ops->create_bitops) {
+		mask_shift = create_constant_bitops(kopnd, kopnd->oper_datatype,
+						    extack);
+		if (IS_ERR(mask_shift)) {
+			err = -EINVAL;
+			goto err;
+		}
+	} else if (kopnd->oper_type == P4TC_OPER_META &&
+		   kopnd->oper_datatype->ops->create_bitops) {
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_metadata *meta;
+
+		if (kopnd->pipeid == P4TC_KERNEL_PIPEID)
+			pipeline = tcf_pipeline_find_byid(NULL, kopnd->pipeid);
+		else
+			pipeline = act->pipeline;
+
+		meta = tcf_meta_find_byid(pipeline, kopnd->immedv);
+		if (!meta) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		mask_shift = create_metadata_bitops(kopnd, meta,
+						    kopnd->oper_datatype,
+						    extack);
+		if (IS_ERR(mask_shift)) {
+			err = -EINVAL;
+			goto err;
+		}
+	} else if (kopnd->oper_type == P4TC_OPER_HDRFIELD ||
+		   kopnd->oper_type == P4TC_OPER_PARAM ||
+		   kopnd->oper_type == P4TC_OPER_REG) {
+		if (kopnd->oper_datatype->ops->create_bitops) {
+			struct p4tc_type_ops *ops = kopnd->oper_datatype->ops;
+
+			mask_shift = ops->create_bitops(kopnd->oper_bitsize,
+							kopnd->oper_bitstart,
+							kopnd->oper_bitend,
+							extack);
+			if (IS_ERR(mask_shift)) {
+				err = -EINVAL;
+				goto err;
+			}
+		}
+	}
+
+	_new_kopnd->oper_mask_shift = mask_shift;
+
+	if (kopnd->path_or_value_sz) {
+		_new_kopnd->path_or_value =
+			kzalloc(kopnd->path_or_value_sz, GFP_KERNEL);
+		if (!_new_kopnd->path_or_value) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		memcpy(_new_kopnd->path_or_value, kopnd->path_or_value,
+		       kopnd->path_or_value_sz);
+	}
+
+	if (kopnd->path_or_value_extra_sz) {
+		_new_kopnd->path_or_value_extra =
+			kzalloc(kopnd->path_or_value_extra_sz, GFP_KERNEL);
+		if (!_new_kopnd->path_or_value_extra) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		memcpy(_new_kopnd->path_or_value_extra,
+		       kopnd->path_or_value_extra,
+		       kopnd->path_or_value_extra_sz);
+	}
+
+	if (kopnd->print_prefix_sz) {
+		_new_kopnd->print_prefix =
+			kzalloc(kopnd->print_prefix_sz, GFP_KERNEL);
+		if (!_new_kopnd->print_prefix) {
+			err = -ENOMEM;
+			goto err;
+		}
+		memcpy(_new_kopnd->print_prefix, kopnd->print_prefix,
+		       kopnd->print_prefix_sz);
+	}
+
+	memcpy(_new_kopnd->immedv_large, kopnd->immedv_large,
+	       kopnd->immedv_large_sz);
+
+	*new_kopnd = _new_kopnd;
+
+	return 0;
+
+err:
+	kfree(_new_kopnd->path_or_value);
+	kfree(_new_kopnd->path_or_value_extra);
+	kfree(_new_kopnd);
+
+	return err;
+}
+
+static int p4tc_cmds_copy_ops(struct p4tc_act *act,
+			      struct p4tc_cmd_operate **new_op_entry,
+			      struct p4tc_cmd_operate *op_entry,
+			      struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operate *_new_op_entry;
+	struct p4tc_cmd_operand *cursor;
+	int err = 0;
+
+	_new_op_entry = kzalloc(sizeof(*_new_op_entry), GFP_KERNEL);
+	if (!_new_op_entry)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&_new_op_entry->operands_list);
+	list_for_each_entry(cursor, &op_entry->operands_list, oper_list_node) {
+		struct p4tc_cmd_operand *new_opnd = NULL;
+
+		err = p4tc_cmds_copy_opnd(act, &new_opnd, cursor, extack);
+		if (new_opnd) {
+			struct list_head *head;
+
+			head = &new_opnd->oper_list_node;
+			list_add_tail(&new_opnd->oper_list_node,
+				      &_new_op_entry->operands_list);
+		}
+		if (err < 0)
+			goto set_results;
+	}
+
+	_new_op_entry->op_id = op_entry->op_id;
+	_new_op_entry->op_flags = op_entry->op_flags;
+	_new_op_entry->op_cnt = op_entry->op_cnt;
+	_new_op_entry->cmd_offset = op_entry->cmd_offset;
+
+	_new_op_entry->ctl1 = op_entry->ctl1;
+	_new_op_entry->ctl2 = op_entry->ctl2;
+	_new_op_entry->cmd = op_entry->cmd;
+
+set_results:
+	*new_op_entry = _new_op_entry;
+
+	return err;
+}
+
+int p4tc_cmds_copy(struct p4tc_act *act, struct list_head *new_cmd_operations,
+		   bool delete_old, struct netlink_ext_ack *extack)
+{
+	struct p4tc_cmd_operate *oplist[P4TC_CMDS_LIST_MAX] = { NULL };
+	int i = 0;
+	struct p4tc_cmd_operate *op;
+	int err;
+
+	if (delete_old)
+		p4tc_cmd_ops_del_list(NULL, new_cmd_operations);
+
+	list_for_each_entry(op, &act->cmd_operations, cmd_operations) {
+		err = p4tc_cmds_copy_ops(act, &oplist[i], op, extack);
+		if (err < 0)
+			goto free_oplist;
+
+		i++;
+	}
+
+	p4tc_cmds_ops_pass_to_list(act, oplist, new_cmd_operations, true);
+
+	return 0;
+
+free_oplist:
+	kfree_tmp_oplist(NULL, oplist, false);
+	return err;
+}
+
+#define SEPARATOR "/"
+
+int p4tc_cmds_parse(struct net *net, struct p4tc_act *act, struct nlattr *nla,
+		    bool ovr, struct netlink_ext_ack *extack)
+{
+	/* XXX: oplist and oplist_attr
+	 * could bloat the stack depending on P4TC_CMDS_LIST_MAX
+	 */
+	struct p4tc_cmd_operate *oplist[P4TC_CMDS_LIST_MAX] = { NULL };
+	struct nlattr *oplist_attr[P4TC_CMDS_LIST_MAX + 1];
+	struct rhashtable *labels = act->labels;
+	int err;
+	int i;
+
+	err = nla_parse_nested(oplist_attr, P4TC_CMDS_LIST_MAX, nla, NULL,
+			       extack);
+	if (err < 0)
+		return err;
+
+	act->labels = kzalloc(sizeof(*labels), GFP_KERNEL);
+	if (!act->labels)
+		return -ENOMEM;
+
+	err = rhashtable_init(act->labels, &p4tc_label_ht_params);
+	if (err < 0) {
+		kfree(act->labels);
+		act->labels = labels;
+		return err;
+	}
+
+	for (i = 1; i < P4TC_CMDS_LIST_MAX + 1 && oplist_attr[i]; i++) {
+		if (!oplist_attr[i])
+			break;
+		err = p4tc_cmd_process_ops(net, act, oplist_attr[i],
+					   &oplist[i - 1], i - 1, extack);
+		if (err) {
+			kfree_tmp_oplist(net, oplist, true);
+
+			if (err == P4TC_CMD_POLICY)
+				err = -EINVAL;
+
+			goto free_labels;
+		}
+	}
+
+	err = cmd_brn_validate(act, oplist, i, extack);
+	if (err < 0) {
+		kfree_tmp_oplist(net, oplist, true);
+		goto free_labels;
+	}
+
+	if (ovr) {
+		p4tc_cmd_ops_del_list(net, &act->cmd_operations);
+		if (labels) {
+			rhashtable_free_and_destroy(labels, p4tc_label_ht_destroy,
+						    NULL);
+			kfree(labels);
+		}
+	}
+
+	/*XXX: At this point we have all the cmds and they are valid */
+	p4tc_cmds_ops_pass_to_list(act, oplist, &act->cmd_operations, false);
+
+	return 0;
+
+free_labels:
+	rhashtable_destroy(act->labels);
+	kfree(act->labels);
+	if (ovr)
+		act->labels = labels;
+	else
+		act->labels = NULL;
+
+	return err;
+}
+
+static void *p4tc_fetch_constant(struct sk_buff *skb,
+				 struct p4tc_cmd_operand *op,
+				 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	if (op->oper_flags & DATA_IS_IMMEDIATE)
+		return &op->immedv;
+
+	return op->immedv_large;
+}
+
+static void *p4tc_fetch_table(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			      struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return op->priv;
+}
+
+static void *p4tc_fetch_result(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			       struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	if (op->immedv == P4TC_CMDS_RESULTS_HIT)
+		return &res->hit;
+	else
+		return &res->miss;
+}
+
+static void *p4tc_fetch_hdrfield(struct sk_buff *skb,
+				 struct p4tc_cmd_operand *op,
+				 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return tcf_hdrfield_fetch(skb, op->priv);
+}
+
+static void *p4tc_fetch_param(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			      struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct tcf_p4act_params *params;
+	struct p4tc_act_param *param;
+
+	params = rcu_dereference(cmd->params);
+	param = idr_find(&params->params_idr, op->immedv2);
+
+	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
+		struct p4tc_cmd_operand *intern_op = param->value;
+
+		return intern_op->fetch(skb, intern_op, cmd, res);
+	}
+
+	return param->value;
+}
+
+static void *p4tc_fetch_key(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			    struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_skb_ext *p4tc_skb_ext;
+
+	p4tc_skb_ext = skb_ext_find(skb, P4TC_SKB_EXT);
+	if (unlikely(!p4tc_skb_ext))
+		return NULL;
+
+	return p4tc_skb_ext->p4tc_ext->key;
+}
+
+static void *p4tc_fetch_dev(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			    struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return &op->immedv;
+}
+
+static void *p4tc_fetch_metadata(struct sk_buff *skb,
+				 struct p4tc_cmd_operand *op,
+				 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return tcf_meta_fetch(skb, op->priv);
+}
+
+static void *p4tc_fetch_reg(struct sk_buff *skb, struct p4tc_cmd_operand *op,
+			    struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_register *reg = op->priv;
+	size_t bytesz;
+
+	bytesz = BITS_TO_BYTES(reg->reg_type->container_bitsz);
+
+	return reg->reg_value + bytesz * op->immedv2;
+}
+
+/* SET A B  - A is set from B
+ *
+ * Assumes everything has been vetted - meaning no checks here
+ *
+ */
+static int p4tc_cmd_SET(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A, *B;
+	void *src;
+	void *dst;
+	int err;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+
+	src = B->fetch(skb, B, cmd, res);
+	dst = A->fetch(skb, A, cmd, res);
+
+	if (!src || !dst)
+		return TC_ACT_SHOT;
+
+	err = p4tc_copy_op(A, B, dst, src);
+
+	if (err)
+		return TC_ACT_SHOT;
+
+	return op->ctl1;
+}
+
+/* ACT A - execute action A
+ *
+ * Assumes everything has been vetted - meaning no checks here
+ *
+ */
+static int p4tc_cmd_ACT(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A = GET_OPA(&op->operands_list);
+	const struct tc_action *action = A->action;
+
+	return action->ops->act(skb, action, res);
+}
+
+static int p4tc_cmd_PRINT(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			  struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A = GET_OPA(&op->operands_list);
+	u64 readval[BITS_TO_U64(P4T_MAX_BITSZ)] = { 0 };
+	struct net *net = dev_net(skb->dev);
+	char name[(TEMPLATENAMSZ * 4)];
+	struct p4tc_type *val_t;
+	void *val;
+
+	A = GET_OPA(&op->operands_list);
+	val = A->fetch(skb, A, cmd, res);
+	val_t = A->oper_datatype;
+
+	if (!val)
+		return TC_ACT_OK;
+
+	p4tc_reg_lock(A, NULL, NULL);
+	if (val_t->ops->host_read)
+		val_t->ops->host_read(val_t, A->oper_mask_shift, val, &readval);
+	else
+		memcpy(&readval, val, BITS_TO_BYTES(A->oper_bitsize));
+	/* This is a debug function, so performance is not a priority */
+	if (A->oper_type == P4TC_OPER_META) {
+		struct p4tc_pipeline *pipeline = NULL;
+		char *path = (char *)A->print_prefix;
+		struct p4tc_metadata *meta;
+
+		pipeline = tcf_pipeline_find_byid(net, A->pipeid);
+		meta = tcf_meta_find_byid(pipeline, A->immedv);
+
+		if (path)
+			snprintf(name,
+				 (TEMPLATENAMSZ << 1) +
+					 P4TC_CMD_MAX_OPER_PATH_LEN,
+				 "%s %s.%s", path, pipeline->common.name,
+				 meta->common.name);
+		else
+			snprintf(name, TEMPLATENAMSZ << 1, "%s.%s",
+				 pipeline->common.name, meta->common.name);
+
+		val_t->ops->print(net, val_t, name, &readval);
+	} else if (A->oper_type == P4TC_OPER_HDRFIELD) {
+		char *path = (char *)A->print_prefix;
+		struct p4tc_hdrfield *hdrfield;
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_parser *parser;
+
+		pipeline = tcf_pipeline_find_byid(net, A->pipeid);
+		parser = tcf_parser_find_byid(pipeline, A->immedv);
+		hdrfield = tcf_hdrfield_find_byid(parser, A->immedv2);
+
+		if (path)
+			snprintf(name, TEMPLATENAMSZ * 4,
+				 "%s hdrfield.%s.%s.%s", path,
+				 pipeline->common.name, parser->parser_name,
+				 hdrfield->common.name);
+		else
+			snprintf(name, TEMPLATENAMSZ * 4, "hdrfield.%s.%s.%s",
+				 pipeline->common.name, parser->parser_name,
+				 hdrfield->common.name);
+
+		val_t->ops->print(net, val_t, name, &readval);
+	} else if (A->oper_type == P4TC_OPER_KEY) {
+		char *path = (char *)A->print_prefix;
+		struct p4tc_table *table;
+		struct p4tc_pipeline *pipeline;
+
+		pipeline = tcf_pipeline_find_byid(net, A->pipeid);
+		table = tcf_table_find_byid(pipeline, A->immedv);
+		if (path)
+			snprintf(name, TEMPLATENAMSZ * 3, "%s key.%s.%s.%u",
+				 path, pipeline->common.name,
+				 table->common.name, A->immedv2);
+		else
+			snprintf(name, TEMPLATENAMSZ * 3, "key.%s.%s.%u",
+				 pipeline->common.name, table->common.name,
+				 A->immedv2);
+		val_t->ops->print(net, val_t, name, &readval);
+	} else if (A->oper_type == P4TC_OPER_PARAM) {
+		char *path = (char *)A->print_prefix;
+
+		if (path)
+			snprintf(name, TEMPLATENAMSZ * 2, "%s param", path);
+		else
+			strcpy(name, "param");
+
+		val_t->ops->print(net, val_t, "param", &readval);
+	} else if (A->oper_type == P4TC_OPER_RES) {
+		char *path = (char *)A->print_prefix;
+
+		if (A->immedv == P4TC_CMDS_RESULTS_HIT) {
+			if (path)
+				snprintf(name, TEMPLATENAMSZ * 2, "%s res.hit",
+					 path);
+			else
+				strcpy(name, "res.hit");
+
+		} else if (A->immedv == P4TC_CMDS_RESULTS_MISS) {
+			if (path)
+				snprintf(name, TEMPLATENAMSZ * 2, "%s res.miss",
+					 path);
+			else
+				strcpy(name, "res.miss");
+		}
+
+		val_t->ops->print(net, val_t, name, &readval);
+	} else if (A->oper_type == P4TC_OPER_REG) {
+		char *path = (char *)A->print_prefix;
+		struct p4tc_pipeline *pipeline;
+		struct p4tc_register *reg;
+
+		pipeline = tcf_pipeline_find_byid(net, A->pipeid);
+		reg = tcf_register_find_byid(pipeline, A->immedv);
+		if (path)
+			snprintf(name, TEMPLATENAMSZ * 2,
+				 "%s register.%s.%s[%u]", path,
+				 pipeline->common.name, reg->common.name,
+				 A->immedv2);
+		else
+			snprintf(name, TEMPLATENAMSZ * 2, "register.%s.%s[%u]",
+				 pipeline->common.name, reg->common.name,
+				 A->immedv2);
+
+		val_t->ops->print(net, val_t, name, &readval);
+	} else {
+		pr_info("Unsupported operand for print\n");
+	}
+	p4tc_reg_unlock(A, NULL, NULL);
+
+	return op->ctl1;
+}
+
+#define REDIRECT_RECURSION_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, redirect_rec_level);
+
+static int p4tc_cmd_SNDPORTEGR(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			       struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct sk_buff *skb2 = skb;
+	int retval = TC_ACT_STOLEN;
+	struct p4tc_cmd_operand *A;
+	struct net_device *dev;
+	unsigned int rec_level;
+	bool expects_nh;
+	u32 *ifindex;
+	int mac_len;
+	bool at_nh;
+	int err;
+
+	A = GET_OPA(&op->operands_list);
+	ifindex = A->fetch(skb, A, cmd, res);
+
+	rec_level = __this_cpu_inc_return(redirect_rec_level);
+	if (unlikely(rec_level > REDIRECT_RECURSION_LIMIT)) {
+		net_warn_ratelimited("SNDPORTEGR: exceeded redirect recursion limit on dev %s\n",
+				     netdev_name(skb->dev));
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	dev = dev_get_by_index_rcu(dev_net(skb->dev), *ifindex);
+	if (unlikely(!dev)) {
+		pr_notice_once("SNDPORTEGR: target device is gone\n");
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	if (unlikely(!(dev->flags & IFF_UP))) {
+		net_notice_ratelimited("SNDPORTEGR: device %s is down\n",
+				       dev->name);
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	nf_reset_ct(skb2);
+
+	expects_nh = !dev_is_mac_header_xmit(dev);
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ?
+				  skb->mac_len :
+				  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
+			skb_pull_rcsum(skb2, mac_len);
+		} else {
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
+		}
+	}
+
+	skb_set_redirected(skb2, skb2->tc_at_ingress);
+	skb2->skb_iif = skb->dev->ifindex;
+	skb2->dev = dev;
+
+	err = dev_queue_xmit(skb2);
+	if (err)
+		retval = TC_ACT_SHOT;
+
+	__this_cpu_dec(redirect_rec_level);
+
+	return retval;
+}
+
+static int p4tc_cmd_MIRPORTEGR(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			       struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct sk_buff *skb2 = skb;
+	int retval = TC_ACT_PIPE;
+	struct p4tc_cmd_operand *A;
+	struct net_device *dev;
+	unsigned int rec_level;
+	bool expects_nh;
+	u32 *ifindex;
+	int mac_len;
+	bool at_nh;
+	int err;
+
+	A = GET_OPA(&op->operands_list);
+	ifindex = A->fetch(skb, A, cmd, res);
+
+	rec_level = __this_cpu_inc_return(redirect_rec_level);
+	if (unlikely(rec_level > REDIRECT_RECURSION_LIMIT)) {
+		net_warn_ratelimited("MIRPORTEGR: exceeded redirect recursion limit on dev %s\n",
+				     netdev_name(skb->dev));
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	dev = dev_get_by_index_rcu(dev_net(skb->dev), *ifindex);
+	if (unlikely(!dev)) {
+		pr_notice_once("MIRPORTEGR: target device is gone\n");
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	if (unlikely(!(dev->flags & IFF_UP))) {
+		net_notice_ratelimited("MIRPORTEGR: device %s is down\n",
+				       dev->name);
+		__this_cpu_dec(redirect_rec_level);
+		return TC_ACT_SHOT;
+	}
+
+	skb2 = skb_clone(skb, GFP_ATOMIC);
+	if (!skb2) {
+		__this_cpu_dec(redirect_rec_level);
+		return retval;
+	}
+
+	nf_reset_ct(skb2);
+
+	expects_nh = !dev_is_mac_header_xmit(dev);
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ?
+				  skb->mac_len :
+				  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
+			skb_pull_rcsum(skb2, mac_len);
+		} else {
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
+		}
+	}
+
+	skb2->skb_iif = skb->dev->ifindex;
+	skb2->dev = dev;
+
+	err = dev_queue_xmit(skb2);
+	if (err)
+		retval = TC_ACT_SHOT;
+
+	__this_cpu_dec(redirect_rec_level);
+
+	return retval;
+}
+
+static int p4tc_cmd_TBLAPP(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			   struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A = GET_OPA(&op->operands_list);
+	struct p4tc_table *table = A->fetch(skb, A, cmd, res);
+	struct p4tc_table_entry *entry;
+	struct p4tc_table_key *key;
+	int ret;
+
+	A = GET_OPA(&op->operands_list);
+	table = A->fetch(skb, A, cmd, res);
+	if (unlikely(!table))
+		return TC_ACT_SHOT;
+
+	if (table->tbl_preacts) {
+		ret = tcf_action_exec(skb, table->tbl_preacts,
+				      table->tbl_num_preacts, res);
+		/* Should check what return code should cause return */
+		if (ret == TC_ACT_SHOT)
+			return ret;
+	}
+
+	/* Sets key */
+	key = table->tbl_key;
+	ret = tcf_action_exec(skb, key->key_acts, key->key_num_acts, res);
+	if (ret != TC_ACT_PIPE)
+		return ret;
+
+	entry = p4tc_table_entry_lookup(skb, table, table->tbl_keysz);
+	if (IS_ERR(entry))
+		entry = NULL;
+
+	res->hit = entry ? true : false;
+	res->miss = !res->hit;
+
+	ret = TC_ACT_PIPE;
+	if (res->hit) {
+		struct p4tc_table_defact *hitact;
+
+		hitact = rcu_dereference(table->tbl_default_hitact);
+		if (entry->acts)
+			ret = tcf_action_exec(skb, entry->acts, entry->num_acts,
+					      res);
+		else if (hitact)
+			ret = tcf_action_exec(skb, hitact->default_acts, 1,
+					      res);
+	} else {
+		struct p4tc_table_defact *missact;
+
+		missact = rcu_dereference(table->tbl_default_missact);
+		if (missact)
+			ret = tcf_action_exec(skb, missact->default_acts, 1,
+					      res);
+	}
+	if (ret != TC_ACT_PIPE)
+		return ret;
+
+	return tcf_action_exec(skb, table->tbl_postacts,
+			       table->tbl_num_postacts, res);
+}
+
+static int p4tc_cmd_BINARITH(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			     struct tcf_p4act *cmd, struct tcf_result *res,
+			     void (*p4tc_arith_op)(u64 *res, u64 opB, u64 opC))
+{
+	u64 result = 0;
+	u64 B_val = 0;
+	u64 C_val = 0;
+	struct p4tc_cmd_operand *A, *B, *C;
+	struct p4tc_type_ops *src_C_ops;
+	struct p4tc_type_ops *src_B_ops;
+	struct p4tc_type_ops *dst_ops;
+	void *src_B;
+	void *src_C;
+	void *dst;
+
+	A = GET_OPA(&op->operands_list);
+	B = GET_OPB(&op->operands_list);
+	C = GET_OPC(&op->operands_list);
+
+	dst = A->fetch(skb, A, cmd, res);
+	src_B = B->fetch(skb, B, cmd, res);
+	src_C = C->fetch(skb, C, cmd, res);
+
+	if (!src_B || !src_C || !dst)
+		return TC_ACT_SHOT;
+
+	dst_ops = A->oper_datatype->ops;
+	src_B_ops = B->oper_datatype->ops;
+	src_C_ops = C->oper_datatype->ops;
+
+	p4tc_reg_lock(A, B, C);
+
+	src_B_ops->host_read(B->oper_datatype, B->oper_mask_shift, src_B,
+			     &B_val);
+	src_C_ops->host_read(C->oper_datatype, C->oper_mask_shift, src_C,
+			     &C_val);
+
+	p4tc_arith_op(&result, B_val, C_val);
+
+	dst_ops->host_write(A->oper_datatype, A->oper_mask_shift, &result, dst);
+
+	p4tc_reg_unlock(A, B, C);
+
+	return op->ctl1;
+}
+
+/* Overflow semantic is the same as C's for u64 */
+static void plus_op(u64 *res, u64 opB, u64 opC)
+{
+	*res = opB + opC;
+}
+
+static int p4tc_cmd_PLUS(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return p4tc_cmd_BINARITH(skb, op, cmd, res, plus_op);
+}
+
+/* Underflow semantic is the same as C's for u64 */
+static void sub_op(u64 *res, u64 opB, u64 opC)
+{
+	*res = opB - opC;
+}
+
+static int p4tc_cmd_SUB(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return p4tc_cmd_BINARITH(skb, op, cmd, res, sub_op);
+}
+
+static void band_op(u64 *res, u64 opB, u64 opC)
+{
+	*res = opB & opC;
+}
+
+static int p4tc_cmd_BAND(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return p4tc_cmd_BINARITH(skb, op, cmd, res, band_op);
+}
+
+static void bor_op(u64 *res, u64 opB, u64 opC)
+{
+	*res = opB | opC;
+}
+
+static int p4tc_cmd_BOR(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return p4tc_cmd_BINARITH(skb, op, cmd, res, bor_op);
+}
+
+static void bxor_op(u64 *res, u64 opB, u64 opC)
+{
+	*res = opB ^ opC;
+}
+
+static int p4tc_cmd_BXOR(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	return p4tc_cmd_BINARITH(skb, op, cmd, res, bxor_op);
+}
+
+static int p4tc_cmd_CONCAT(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			   struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	u64 RvalAcc[BITS_TO_U64(P4T_MAX_BITSZ)] = { 0 };
+	size_t rvalue_tot_sz = 0;
+	struct p4tc_cmd_operand *cursor;
+	struct p4tc_type_ops *dst_ops;
+	struct p4tc_cmd_operand *A;
+	void *dst;
+
+	A = GET_OPA(&op->operands_list);
+
+	cursor = A;
+	list_for_each_entry_continue(cursor, &op->operands_list, oper_list_node) {
+		size_t cursor_bytesz = BITS_TO_BYTES(cursor->oper_bitsize);
+		struct p4tc_type *cursor_type = cursor->oper_datatype;
+		struct p4tc_type_ops *cursor_type_ops = cursor_type->ops;
+		void *srcR = cursor->fetch(skb, cursor, cmd, res);
+		u64 Rval[BITS_TO_U64(P4T_MAX_BITSZ)] = { 0 };
+
+		cursor_type_ops->host_read(cursor->oper_datatype,
+					   cursor->oper_mask_shift, srcR,
+					   &Rval);
+		cursor_type_ops->host_write(cursor->oper_datatype,
+					    cursor->oper_mask_shift, &Rval,
+					    (char *)RvalAcc + rvalue_tot_sz);
+		rvalue_tot_sz += cursor_bytesz;
+	}
+
+	dst = A->fetch(skb, A, cmd, res);
+	dst_ops = A->oper_datatype->ops;
+	dst_ops->host_write(A->oper_datatype, A->oper_mask_shift, RvalAcc, dst);
+
+	return op->ctl1;
+}
+
+static int p4tc_cmd_JUMP(struct sk_buff *skb, struct p4tc_cmd_operate *op,
+			 struct tcf_p4act *cmd, struct tcf_result *res)
+{
+	struct p4tc_cmd_operand *A;
+
+	A = GET_OPA(&op->operands_list);
+
+	return A->immedv;
+}
diff --git a/net/sched/p4tc/p4tc_meta.c b/net/sched/p4tc/p4tc_meta.c
index ebeb73352..d4c340473 100644
--- a/net/sched/p4tc/p4tc_meta.c
+++ b/net/sched/p4tc/p4tc_meta.c
@@ -202,6 +202,71 @@ static int p4tc_check_meta_size(struct p4tc_meta_size_params *sz_params,
 	return new_bitsz;
 }
 
+static inline void *tcf_meta_fetch_kernel(struct sk_buff *skb,
+					  const u32 kernel_meta_id)
+{
+	switch (kernel_meta_id) {
+	case P4TC_KERNEL_META_QMAP:
+		return &skb->queue_mapping;
+	case P4TC_KERNEL_META_PKTLEN:
+		return &skb->len;
+	case P4TC_KERNEL_META_DATALEN:
+		return &skb->data_len;
+	case P4TC_KERNEL_META_SKBMARK:
+		return &skb->mark;
+	case P4TC_KERNEL_META_TCINDEX:
+		return &skb->tc_index;
+	case P4TC_KERNEL_META_SKBHASH:
+		return &skb->hash;
+	case P4TC_KERNEL_META_SKBPRIO:
+		return &skb->priority;
+	case P4TC_KERNEL_META_IFINDEX:
+		return &skb->dev->ifindex;
+	case P4TC_KERNEL_META_SKBIIF:
+		return &skb->skb_iif;
+	case P4TC_KERNEL_META_PROTOCOL:
+		return &skb->protocol;
+	case P4TC_KERNEL_META_PKTYPE:
+	case P4TC_KERNEL_META_IDF:
+	case P4TC_KERNEL_META_IPSUM:
+	case P4TC_KERNEL_META_OOOK:
+	case P4TC_KERNEL_META_PTYPEOFF:
+	case P4TC_KERNEL_META_PTCLNOFF:
+		return &skb->__pkt_type_offset;
+	case P4TC_KERNEL_META_FCLONE:
+	case P4TC_KERNEL_META_PEEKED:
+	case P4TC_KERNEL_META_CLONEOFF:
+		return &skb->__cloned_offset;
+	case P4TC_KERNEL_META_DIRECTION:
+		return &skb->__pkt_vlan_present_offset;
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+static inline void *tcf_meta_fetch_user(struct sk_buff *skb, const u32 skb_off)
+{
+	struct p4tc_skb_ext *p4tc_skb_ext;
+
+	p4tc_skb_ext = skb_ext_find(skb, P4TC_SKB_EXT);
+	if (!p4tc_skb_ext) {
+		pr_err("Unable to find P4TC_SKB_EXT\n");
+		return NULL;
+	}
+
+	return &p4tc_skb_ext->p4tc_ext->metadata[skb_off];
+}
+
+void *tcf_meta_fetch(struct sk_buff *skb, struct p4tc_metadata *meta)
+{
+	if (meta->common.p_id != P4TC_KERNEL_PIPEID)
+		return tcf_meta_fetch_user(skb, meta->m_skb_off);
+
+	return tcf_meta_fetch_kernel(skb, meta->m_id);
+}
+
 void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline)
 {
 	u32 meta_off = START_META_OFFSET;
-- 
2.34.1

