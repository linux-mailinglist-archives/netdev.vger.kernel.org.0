Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237A60DC7A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiJZHvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiJZHvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:51:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A506D9FA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso1632689pjg.5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UJmG1jd29o/BEowxnkWmHL1o7dxm7JkuePNMr5Nki2s=;
        b=1Vgz4VPf7KHSaGLwHv9Jw2wQ8QwSXEIAMXXu3+nE+OnPUjoVVT/NZDb+TLljHtXV2i
         +SQ4roDd7WEnwKYqQMh9OCUTx71kXMJbkyoLVab1QwLLEvZRipAbDNdeunFTnxdLG6kq
         OGDXTN4uME+zB0rzokb3Kxp5SlQjyihH+x5/nl0MkaEsqxntvKo5vj8TwfZCxQvS8PRl
         hn019cV6UhcATPt7nYrhpHcJew+yzkePnEB0+UMXMsKy9bIl5aKmJmZHxqXbFL3aLqiB
         KVQ6+TP+3N3JYwjKuQYfLo8yJSk2ABU17ZsNIe36Don4sigoHLBe7UYiI1UooWVfLxnG
         e+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UJmG1jd29o/BEowxnkWmHL1o7dxm7JkuePNMr5Nki2s=;
        b=t2zAlKIi6UtIeH6aF0scxJ5DjbTV/LdBpT2cpK/gWLoIqyfP0ej81KHoH2/AYxGfw6
         QEllr6I/B0xZKgt7NJi4n1QQj2svP0MhbJZz9BOHSY2FEOXZp9tC3/aVMuJNJHSOtf8G
         7RcDI9o3n2QJckTOMMjoY9/GorbKM4DhU45LMVU55HW516O2TfnzzjSDCpKnawrAyoc+
         x/xKjyRXHQCUnNaMo76gyzcWHtYvFpMcGIscpe+n+srxh4Oh8idPQtL/VHjoqVuWVwXO
         +/Om6FqavXCRf4WYZwu2rtl05VgEaF6zvmvz+lsRqp6Nlqu57SquESf1tQkgDPr8HbXA
         O5ew==
X-Gm-Message-State: ACrzQf2wxYi5kaOgsm4c3lDw7q8B6QmVo+lULhbGOa+YD/rpkqkbdd1r
        OTTjRmykmJUfdm4CgA5kfOTgQHZO0mjI2w==
X-Google-Smtp-Source: AMsMyM7GLbDo9JxSY4jOjA4oggSkiyN4QIg6GculUAoFxovjRS/I7f3VGq7OqyyCDyP61RjhbA2uyQ==
X-Received: by 2002:a17:902:dac3:b0:186:a437:f4b8 with SMTP id q3-20020a170902dac300b00186a437f4b8mr15237791plx.70.1666770663000;
        Wed, 26 Oct 2022 00:51:03 -0700 (PDT)
Received: from linkdev2.localdomain ([49.37.37.214])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b001714e7608fdsm2310913pld.256.2022.10.26.00.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 00:51:02 -0700 (PDT)
From:   Pratyush Kumar Khan <pratyush@sipanda.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     tom@sipanda.io, abuduri@ventanamicro.com, chethan@sipanda.io,
        Pratyush Kumar Khan <pratyush@sipanda.io>
Subject: [RFC PATCH net-next]net: Add new kParser KMOD in net, integrate kParser with XDP
Date:   Wed, 26 Oct 2022 13:20:50 +0530
Message-Id: <20221026075054.119069-1-pratyush@sipanda.io>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kParser, or the "Kernel Parser" is a highly programmable, high
performance protocol parser in the Linux network stack. An instance
of kParser is programmed by "ip parser ..." commands in iproute2.

The kParser is dynamically programmable and script-able. For instance,
to add new protocol to parse in an existing instance of kparser, CLI
commands are executed -- there is no need to write user code or perform
a recompile of the parser.

A parser is programmed through the "ip parser" CLI, and common netlink
interfaces are used to instantiate a parser in the kernel. A parser is
defined by a parse graph which is implemented by kparser as a set of
parse node definitions and protocol tables that describe the linkages
between the nodes. Per its program, a kparser instance will report
metadata about the packet and various protocols layers of the packet.
Metadata is any information about the packet including header offsets
and value of fields of interest to the programmer; the later is
analogous to the flow information extracted by flow dissector (the
primary difference being that kParser can extract arbitrary protocol
fields and report on fields in multiple layers of encapsulation).

kParser is called in the kernel by the kparser_parse and
__kparser_parse functions. The output returned is a set metadata about
the parsed packet. Metadata is any information that the parser is
programmed to report about a packet (e.g. offsets of various headers,
extracted IP addresses and ports, etc.). A pointer to a metadata buffer
is input to kparser_parse, kparser will fill in the metadata as per
the programming of the parser. Note that the structure of the metadata
buffer is determined by the programmer, when the buffer is returned
the caller can cast the buffer to the data structure for that parser.

The iproute2 CLI for the kParser works in tandem with the KMOD kParser
to configure any number of parser instances. If kParser KMOD is not
statically compiled with Linux kernel, it needs to be
additionally enabled, compiled and loaded to use the iproute2 CLI for
kParser. Please note that the kParser CLI is scriptable meaning the
parser configuration in the kernel can by dynamically updated without
need to recompile any code or reload kernel module.

Building blocks of kParser are various objects from different
namespaces/object types. For example, parser, node, table etc. are all
different types of objects, also known as namespaces. All the namespaces
are described in the next section.

Each object is identified by a maximum 128 bytes long '\0' terminated
(128 bytes including the '\0' character) human readable ASCII name (only
character '/' is not allowed in the name, and names can not start with
'-'). Alternatively an unsigned 16 bit ID or both ID and name can be
used to identify objects.
NOTE: During CLI create operations of these objects, it is must to
specify either the name or ID. Both can also be specified.
Whichever is not specified during create will be auto generated by the
KMOD kParser and CLI will convey the identifiers to user for later use.
User should save these identifiers.
NOTE: During CLI create operations, unique name or ID must always be
specified. Those name/ID can later be used to identify the associated
object in further CLI operations.

Various objects are:
* parser:
	A parser represents a parse tree. It defines the user
	metadata and metametadata structure size, number of parsing node
	and encapsulation limits, root node for the parse tree, success
	and failure case exit nodes.

* node:
	A node (a.k.a parse node) represents a specific protocol header.
	Defining protocol handler involves multiple work, i.e.configure
	the parser about the associated protocol's packet header, e.g.
	minimum header length, where to look for the next protocol field
	in the packet, etc.
	Along with that, it also defines the rules/handlers to parse and
	store the required metadata by associating a metalist.
	The table to find the next protocol node is attached to node.
	node can be 3 types:
		* PLAIN:
			PLAIN nodes are the basic protocol headers.
		* TLVS:
			TLVS nodes are the Type-Length-Value protocol
			headers, such as TCP.
			They also binds a tlvtable to a node.
		* FLAGFIELDS:
			FLAGFIELDS are indexed flag and associated flag
			fields protocol headers, such as GRE headers.
			It also binds a flagstable with a node.

* table:
	A table is a protocol table, which associated a protocol
	number with a node. e.g. Ethernet protocol type 0x8000 in
	network order means the next node after Ethernet header is IPv4.

	NOTE: table has key, key must be unique. Usually this key is
	protocol number, such as Ethernet type, or IPv4 protocol number
	etc.

* metadata-rule:
	Defines the metadata structures that will be passed to
	the kParser datapath parser API by the user. This basically
	defines a specific metadata extraction rule. This must match
	with the user passed metadata structure in the datapath API.

* metadata-ruleset:
	A list of metadata(s) to associate it with packet
	parsing action handlers, i.e. parse node.

* tlvnode:
	A tlvnode defines a specific TLV parsing rule, e.g. to
	parse TCP option MSS, a new tlvnode needs to be defined.
	Each tlvnode can also associate a metalist with the TLV parsing
	rule, i.e. tlvnode

* tlvtable:
	This is a table of multiple tlvnode(s) where the key are
	types of TLVs (e.g. tlvnode defined for TCP MSS should have the
	type/kind value set to 2.

* flags:
	It describes parsing rules to extract certain protocol's flags
	in bitfields, such as flag value, mask and size.

* flagfields:
	It defines flagfields in packet associated with flags in
	bitfields of the same packet.
	e.g. GRE flagfields such as checksum, key, sequence number etc.

* flagstable:
	This defines a table of flagfields and associate them
	with their respective flag values via their indexes. Here the
	keys are usually indexes, because in typical flag based protocol
	header, such as GRE, the flagfields appear in protocol packet in
	the same order as the set flag bits. The flag is defined by the
	flag value, mask, size and associated metalist.

* condexprs:
	"Conditional expressions" used to define and configure
	various complex conditional expressions in kParser.
	They are used to validate certain conditions for
	protocol packet field values.

* condexprslist:
	"List of Conditional expressions" used to create
	more complex and composite expressions involving more than one
	conditional expression(s).

* condexprstable:
	"A table of Conditional expressions" used to
	associate one or more than one list of Conditional expressions
	with a packet parsing action handlers, i.e. parse node.

* counter:
	It is used to create and configure counter objects which can
	be used for a wide range of usages such as count how many VLAN
	headers were parsed, how many TCP options are encountered etc.

* countertable:
	kParser has a global table of counters, which supports various
	and unique counter configurations upto seven entries. Multiple
	kParser parser instances can share this countertable.

Global header file include/net/kparser.h exports the kParser datapath
KMOD APIs. The APIs are:

/* kparser_parse(): Function to parse a skb using a parser instance key.
 *
 * skb: input packet skb
 * kparser_key: key of the associated kParser parser object which must
 *     be already created via CLI.
 * _metadata: User provided metadata buffer. It must be same as
 *
 * configured metadata objects in CLI.
 * metadata_len: Total length of the user provided metadata buffer.
 *
 * return: kParser error code as defined in include/uapi/linux/kparser.h
 */
        int kparser_parse(struct sk_buff *skb,
                          const struct kparser_hkey *kparser_key,
                          void *_metadata, size_t metadata_len);

/* __kparser_parse(): Function to parse a void * packet buffer using a
 * parser instance key.
 *
 * parser: Non NULL kparser_get_parser() returned and cached opaque
 *     pointer referencing a valid parser instance.
 * _hdr: input packet buffer
 * parse_len: length of input packet buffer
 * _metadata: User provided metadata buffer. It must be same as
 *     configured metadata objects in CLI.
 * metadata_len: Total length of the user provided metadata buffer.
 *
 * return: kParser error code as defined in include/uapi/linux/kparser.h
 */
        int __kparser_parse(const void *parser, void *_hdr,
                            size_t parse_len, void *_metadata,
                            size_t metadata_len);

/* kparser_get_parser(): Function to get an opaque reference of a parser
 * instance and mark it immutable so that while actively using, it can
 * not be deleted. The parser is identified by a key. It marks  the
 * associated parser and whole parse tree immutable so that when it is
 * locked, it can not be deleted.
 *
 * kparser_key: key of the associated kParser parser object which must
 *     be already created via CLI.
 *
 * return: NULL if key not found, else an opaque parser instance pointer
 *     which can be used in the following APIs 3 and 4.
 *
 * NOTE: This call makes the whole parser tree immutable. If caller
 * calls this more than once, later caller will need to release the same
 * parser exactly that many times using the API kparser_put_parser().
 */
        const void *kparser_get_parser(const struct kparser_hkey
                                       *kparser_key);

/* kparser_put_parser(): Function to return and undo the read only
 * operation done previously by kparser_get_parser(). The parser
 * instance is identified by using a previously obtained opaque parser
 * pointer via API kparser_get_parser(). This undo the immutable
 * change so that any component of the whole parse tree can be deleted
 * again.
 *
 * parser: void *, Non NULL opaque pointer which was previously returned
 *     by kparser_get_parser(). Caller can use cached opaque pointer as
 *     long as system does not restart and kparser.ko is not reloaded.
 *
 * return: boolean, true if put operation is success, else false.
 *
 * NOTE: This call makes the whole parser tree deletable for the very
 * last call.
 */
        bool kparser_put_parser(const void *parser);

Now we can refer to an example kParser configuration which can parse
simple IPv4 five tuples, i.e. IPv4 header offset, offset of IPv4
addresses, IPv4 protocol number, L4 header offset (i.e. TCP/UDP) and
L4 port numbers. The sample ip commands are:

ip parser create md-rule name md.iphdr_offset type offset md-off 0

ip parser create md-rule name md.ipaddrs src-hdr-off 12 length 8 \
	md-off 4

ip parser create md-rule name md.l4_hdr.offset type offset md-off 2

ip parser create md-rule name md.ports src-hdr-off 0 length 4 \
	md-off 12 isendianneeded true

ip parser create node name node.ports hdr.minlen 4 \
	md-rule md.l4_hdr.offset md-rule md.ports

ip parser create node name node.ipv4 hdr.minlen 20 \
	hdr.len-field-off 0 hdr.len-field-len 1 \
	hdr.len-field-mask 0x0f hdr.len-field-multiplier 4 \
	nxt.field-off 9 nxt.field-len 1 \
	nxt.table-ent 6:node.ports nxt.table-ent 17:node.ports \
	md-rule md.iphdr_offset \
	md-rule md.ipaddrs

ip parser create node name node.ether hdr.minlen 14 nxt.offset 12 \
	nxt.length 2 nxt.table-ent 0x800:node.ipv4

ip parser create parser name tuple_parser rootnode node.ether \
	base-metametadata-size 14

This sample parser will parse Ethernet/IPv4 to UDP and TCP, report the
offsets of the innermost IP and TCP or UDP header, extract IPv4
addresses and UDP or TCP ports (into a frame).

About the XDP kParser integration changes:

xdp: Support for kParser as bpf helper function

bpf xdp helper function is defined for kernel
parser(kParser).kParser is configured via userspace
ip command.
       kParser data path API's as mentioned in include/net/kparser.h
       are called using registered callback hooks.    
       xdp frame buffer is passed on to kParser via the xdp helper
       function and metadata is populated in the user
       specified buffer.
           
       xdp user space component, which loads xdp kernel component
       into xdp hook . when xdp packet is received by the xdp prog
       in kernel calls bpf helper function to pass kparser configuration
       and buffer to collect the metadata mapped to bpf map.
       so that bpftool can display the metadata in BTF format.
       
       kParser user space component displays number of packets
       transmitted/received per second.
           
       Following are the steps to test/run the kParser with xdp,

- load the kParser module
- configure the kparser via  ip command
 
The ip command can be used to load the xdp kernel
component of xdp kParser.
ip link set dev <interface-name> xdp obj  \
xdp_kparser_kern.o verbose
                
  below is the command to run kParser on network interface
 ./xdp_kparser -S <interface-name>
         
xdp: Support for flow dissector  as bpf helper function

xdp program which is loaded into the xdp hook calls the xdp
helper function to get the metadata.

bpf xdp helper function is defined for flow dissector.
    xdp frame is passed on to Flow dissector call and with
    keys(either basic keys or big parser keys) .
    bpf helper function calls __skb_flow_dissector() with xdp
    buffer, keys and user specified buffer for metadata.
    xdp frame is passed via xdp helper function and metadata is
    populated in the user specified buffer.
       
    xdp user space component, which loads xdp kernel component
    into xdp hook and displays number of packets
    transmitted/received per second.

below is the command to run flow dissector on network
interface
 ./xdp_flow_dissector -S <interface-name>
 
The ip command can be used to load the xdp kernel
component of flow_dissector.
ip link set dev <interface-name> xdp obj     \
xdp_flow_dissector_kern.o verbose

---

Aravind Kumar Buduri (2):
  xdp: Support for kParser as bpf helper function
  xdp: Support for flow_dissector as bpf helper function

Pratyush (1):
  kParser: Add new kParser KMOD

Pratyush Kumar Khan (1):
  docs: networking: add doc entry for kParser

 Documentation/networking/kParser.rst          |  302 ++
 .../networking/parse_graph_example.svg        | 2039 ++++++++++
 include/net/kparser.h                         |   90 +
 include/uapi/linux/bpf.h                      |   20 +
 include/uapi/linux/kparser.h                  |  678 +++
 net/Kconfig                                   |    9 +
 net/Makefile                                  |    1 +
 net/core/filter.c                             |  244 ++
 net/kparser/Makefile                          |   10 +
 net/kparser/kparser.h                         |  391 ++
 net/kparser/kparser_cmds.c                    |  898 ++++
 net/kparser/kparser_cmds_dump_ops.c           |  532 +++
 net/kparser/kparser_cmds_ops.c                | 3621 +++++++++++++++++
 net/kparser/kparser_condexpr.h                |   52 +
 net/kparser/kparser_datapath.c                | 1094 +++++
 net/kparser/kparser_main.c                    |  325 ++
 net/kparser/kparser_metaextract.h             |  896 ++++
 net/kparser/kparser_types.h                   |  586 +++
 samples/bpf/Makefile                          |    6 +
 samples/bpf/metadata_def.h                    |   21 +
 samples/bpf/xdp_flow_dissector_kern.c         |   91 +
 samples/bpf/xdp_flow_dissector_user.c         |  170 +
 samples/bpf/xdp_kparser_kern.c                |   94 +
 samples/bpf/xdp_kparser_user.c                |  171 +
 tools/include/uapi/linux/bpf.h                |   20 +
 25 files changed, 12361 insertions(+)
 create mode 100644 Documentation/networking/kParser.rst
 create mode 100644 Documentation/networking/parse_graph_example.svg
 create mode 100644 include/net/kparser.h
 create mode 100644 include/uapi/linux/kparser.h
 create mode 100644 net/kparser/Makefile
 create mode 100644 net/kparser/kparser.h
 create mode 100644 net/kparser/kparser_cmds.c
 create mode 100644 net/kparser/kparser_cmds_dump_ops.c
 create mode 100644 net/kparser/kparser_cmds_ops.c
 create mode 100644 net/kparser/kparser_condexpr.h
 create mode 100644 net/kparser/kparser_datapath.c
 create mode 100644 net/kparser/kparser_main.c
 create mode 100644 net/kparser/kparser_metaextract.h
 create mode 100644 net/kparser/kparser_types.h
 create mode 100644 samples/bpf/metadata_def.h
 create mode 100644 samples/bpf/xdp_flow_dissector_kern.c
 create mode 100644 samples/bpf/xdp_flow_dissector_user.c
 create mode 100644 samples/bpf/xdp_kparser_kern.c
 create mode 100644 samples/bpf/xdp_kparser_user.c

-- 
2.34.1

